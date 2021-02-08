;;;;;;;;;;;;;;;;;;;;;; WRITING TO PPU ;;;;;;;;;;;;;;;;;;;;
;;  This method writes data to ppu from drawing buffer
;;  expects:
;;    in x: length of data to copy
;;    in ppu_pointer: adress to write on PPU (HI, LO format)
;;    in ppu_data_address: address of data to write to PPU

WriteToPPU:
  lda $2002                  ; read PPU status to reset the high/low latch
  lda ppu_pointer
  sta $2006                  ; write the high byte of $3F00 address
  lda ppu_pointer+1
  sta $2006                  ; write the low byte of $3F00 address

  ldy #$00

.loop:
  lda [ppu_data_address], y  ; load data from the address stored at indexed by ppu_data_address X
  sta $2007                  ; write to PPU
;; increment data adress, simple iny is not the best solution, becuse for it to work properly
;; all data needs to be in the same page, otherwise overflow -> garbage
  inc ppu_data_address
  bne .loop_done             ; if Z flag set, we rolled over, thus need to increment HI byte
  inc ppu_data_address+1
  
.loop_done:
  dex                        ; decrement loop counter
  bne .loop                  ; when counter is 0 we are done

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;; WRITING TO PPU RLE ;;;;;;;;;;;;;;;;;;;;
;;  This method writes data compressed in RLE format described
;;  below to ppu from drawing buffer
;;  expects:
;;    in x: length of data to copy. Important: it is the length to WRITE and not length to READ!!!
;;    in ppu_pointer: adress to write on PPU (HI, LO format)
;;    in ppu_data_address: address of data to write to PPU

WriteToPPU_RLE:
  lda $2002                  ; read PPU status to reset the high/low latch
  lda ppu_pointer
  sta $2006                  ; write the high byte of $3F00 address
  lda ppu_pointer+1
  sta $2006                  ; write the low byte of $3F00 address

  lda #$00                   ; reset the RLE byte counter
  sta ppu_rle_byte_counter

.main_loop:
  ldy #$00
  lda [ppu_data_address], y  ; load data from the address stored at indexed by ppu_data_address X
;; Save A for now
  sta ppu_temp2
;; Increment data address
  inc ppu_data_address
  bne .read_byte            ; if Z flag set, we rolled over, thus need to increment HI byte
  inc ppu_data_address+1

.read_byte:
  lda [ppu_data_address], y
  ldy ppu_temp2             ; load num of repetitions

.rle_loop:
  sta $2007                 ; write to PPU
  dex                       ; decrement data length counter
  beq .inc_addr             ; if data length counter reaches 0 before rle counter, we stop writing
  dey                       ; decrement rle loop counter
  bne .rle_loop

.inc_addr:
  inc ppu_data_address
  bne .no_rollover          ; if Z flag set, we rolled over, thus need to increment HI byte
  inc ppu_data_address+1

.no_rollover:
  inc ppu_rle_byte_counter  ; Each set of data is 2 bytes so increase byte counter twice
  inc ppu_rle_byte_counter

  cpx #$00
  bne .main_loop             ; when data length counter is 0 we are done

.done:
  rts

;;;;;;;;;;;;;;;;; LOAD SCREEN DATA to PPU FROM buffer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Buffer format:
;;  byte 0: length of data
;;  byte 1: HI byte of target PPU address
;;  byte 2: LO byte of target PPU address
;;  byte 3: FLAGS:
;;    7 6 5 4 3 2 1 0
;               | | |
;               | | x --- vertical or horizontal: if 0 horizantal (PPU addr increment 1), if 1: vertical (PPU addr increment by 32)
;               | x ----- set if data is in ROM  (in this case byte 4(HI) and 5(LO) are the address bytes)
;               x ------- RLE (Run length encoding): set if data is RLE
;
;               At the moment if increment by 32 is on, only 1 coloumn (30 bytes) can be copied at once, cuz PPU won't jump to next coloumn
;               and keeps increasing address by 32, and will fill the VRAM with garbage.
;
;;  if copy from RAM:
;;    - data from byte 4 onwards
;;
;;  if copy from ROM:
;;    - in this case byte 5(LO) and 6(HI) are the address bytes
;;
;;  if RLE:
;;    -- whether if in ROM or RAM, data must be as follows:
;;     - byte 4: number of repetitions of first byte
;;     - byte 5: first byte to repeat
;;     - after this alternate these two info

draw_from_buffer:
  ldy #$00

.header_loop:
  lda DRAW_BUFFER, y
  beq .done ;; if 0 buffer is empty, we are done
  tax       ;; if not this byte is data length
  iny

  lda DRAW_BUFFER, y    ;set the target PPU address
  sta ppu_pointer
  iny
  lda DRAW_BUFFER, y
  sta ppu_pointer+1

.check_flags:
  ;check if incrementing by 1 or 32. if 1 do nothing cuz we always reset this bit
  iny
  lda DRAW_BUFFER, y
  ror a                   ; push bit 0 to carry
  bcc .check_source       ; if 1 we set inc by 32 mode if 0 we skip
  pha                     ; push A t o stack
  lda ppu_control_soft
  ora #%00000100
  sta $2000
  pla                     ;restore A to prev value

.check_source:
  ror a
  bcc .data_in_RAM
;; data is in ROM if we came this far
  pha                     ; push A to stack
  iny                     ; save memory address for PPU write subroutine
  lda DRAW_BUFFER, y
  sta ppu_data_address
  iny
  lda DRAW_BUFFER, y
  sta ppu_data_address+1

  lda #$00                ; If data is in ROM we already read all data related from buffer
  sta ppu_temp1           ; so later won't need to skip any bytes

  pla                     ;restore A to prev value
  jmp .check_rle

.data_in_RAM:
  pha                     ; push A to stack

  iny
  sty ppu_data_address    ; Y is the low byte of data address in buffer
  dey                     ; otherwise next data read will be corrupted

  lda #DRAW_BUFFER_HIGH
  sta ppu_data_address+1  ; and high byte is stored in constant ($04)
  pla                     ; restore A to prev value

  stx ppu_temp1           ; If data is in RAM we will need to skip the bytes read
                          ; in this loop to find next data

.check_rle:
  ror a
  bcs .is_rle

  tya                     ; store X and Y in sthe stack
  pha
  txa
  pha

  jsr WriteToPPU          ; if not RLE call WriteToPPU subroutine
  jmp .done_writing

.is_rle:

  tya                     ; store X and Y in sthe stack
  pha
  txa
  pha

  jsr WriteToPPU_RLE

  ;; If data was in ROM, ppu_temp1 is 0, otherwise greater than 0
  ;; so we can determine if we need to skip any bytes
  lda ppu_temp1
  beq .done_writing
  lda ppu_rle_byte_counter
  sta ppu_temp1


.done_writing:
  pla                    ; restore X and Y from stack
  tax
  pla

  clc
  adc ppu_temp1          ; add the num of bytes needed to skip
  tay
  iny                    ; and go to next byte to read

  ;clear the inc 32 bit on PPU Control register, just in case
  lda ppu_control_soft
  and #%11110111
  sta $2000

  jmp .header_loop

.done
  ; set first byte of buffer to 0 to indicate that buffer is done with
  lda #$00
  sta DRAW_BUFFER

  rts
