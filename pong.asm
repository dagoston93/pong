;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TODO:
;;;   -- change assembler to NESASM                                         -- DONE
;;;   -- jump table for gamestates                                          -- DONE
;;;   -- separate parts to files                                            -- DONE
;;;   -- separate game engine and NMI                                       -- DONE
;;;   -- use same code for P1 and P2, with indexing
;;;   -- re-write joypad checking, delete pause and select counters         -- DONE
;;;   -- use graphics buffer, use this format to store "map" data (RLE)     -- DONE
;;;   -- add sound engine and effects
;;;   -- let player choose paddle color                                     -- DONE
;;;   -- animate the ball
;;;   -- add a kinda AI for CPU opponent
;;;   -- properly handle ppu $2000 and $2001 changes
;;;   -- find out ways to make gameplay exciting and implement them
;;;      --- items to pick up:
;;;          ---- longer paddle
;;;          ---- shorter paddle
;;;          ---- shoot at opponents paddle
;;;          ---- freeze opponent for a moment
;;;          ---- ball multiplier
;;;          ---- ball goes faster towards opponent
;;;          ---- temporary wall in the middle
;;;          ---- ball random repositioning

;;;;;;;;;;;;;;;;; iNES HEADER ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .inesprg 2 ;1x 16kb PRG code
  .ineschr 1 ;1x 8kb CHR data
  .inesmap 0 ; mapper 0 = NROM, no bank swapping
  .inesmir 1 ;background mirroring (vertical mirroring = horizontal scrolling)

;;;;;;;;;;;;;;;; VARIABLES  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .rsset $0000
gamestate:              .rs 1  ; We store state of the game here for game engine
jump_pointer:           .rs 2  ; Pointer used to jump to correct game engine subroutine
sleeping:               .rs 1  ; We wake up game engine once per frame using this variable
ballx:                  .rs 1  ; ball horizontal position
bally:                  .rs 1  ; ball vertical position
ballup:                 .rs 1  ; 1 = ball moving up
balldown:               .rs 1  ; 1 = ball moving down
ballleft:               .rs 1  ; 1 = ball moving left
ballright:              .rs 1  ; 1 = ball moving right
ballspeedx:             .rs 1  ; ball horizontal speed per frame
ballspeedy:             .rs 1  ; ball vertical speed per frame
paddle1ytop:            .rs 1  ; player 1 paddle top vertical position
paddle2ytop:            .rs 1  ; player 2 paddle bottom vertical position - well...I use it as if it was paddle2ytop... no point to handle 1 paddle different than other
joypad1_current:        .rs 1  ; player 1 joypad buttons read this frame
joypad2_current:        .rs 1  ; player 2 joypad buttons read this frame
joypad1_old:            .rs 1  ; player 1 joypad buttons read previous frame
joypad2_old:            .rs 1  ; player 2 joypad buttons read previous frame
joypad1_pressed:        .rs 1  ; player 1 joypad buttons pressed this frame
joypad2_pressed:        .rs 1  ; player 2 joypad buttons pressed this frame
score1:                 .rs 1  ; player 1 score, 0-15
score2:                 .rs 1  ; player 2 score, 0-15
score_option_selected:  .rs 1  ; the selected winning score option
current_option:         .rs 1  ; on title screen: 0 if winning score is being set, 1 if colors
player1_color:          .rs 1  ; the selected color for player 1 paddle
player2_color:          .rs 1  ; the selected color for player 1 paddle
ball_released:          .rs 1  ; 1 if the ball was released
lastscorer:             .rs 1  ; 0 in beginning, 1 if P1, 2 if P2
winningscore:           .rs 1  ; when a player reaches this score, game is over
selected_option:        .rs 1  ; the option selected on title screen
number_of_players:      .rs 1  ; 1 if 2 player mode selected, 0 if not
pointerLo:              .rs 1  ; Low byte of a pointer
pointerHi:              .rs 1  ; High byte of a pointer
need_draw:              .rs 1  ; 1 if drawing from buffer needed
need_palette_update:    .rs 1  ; pallettes shall be updated only during vblank so singal to NMI if needed
ppu_pointer:            .rs 2  ; Using this to write to PPU (HI byte first)
ppu_data_address:       .rs 2  ; Address of data to write to PPU
ppu_control_soft:       .rs 1  ; Buffer for required PPU control ($2000)
ppu_mask_soft:          .rs 1  ; Buffer for required PPU mask ($2001)
ppu_mask_prev:          .rs 1  ; Keep the previous value if we turn the screen off
ppu_temp1:              .rs 1  ; Temporary variable for ppu
ppu_temp2:              .rs 1  ; Temporary variable for ppu
ppu_rle_byte_counter:   .rs 1  ; This counter stores the num of bytes read from memory while loading RLE encoded data
random_0_to_5:          .rs 1  ; This helps choosing random paddle color for computer
need_update_random:     .rs 1  ; This indicates to NMI to update this number
palette_buffer:         .rs 32 ; We keep our palette data in this buffer and when updates are made, NMI will tell the PPU
h_scroll:               .rs 1  ; Horizontal scroll value. usually 0, except when title screen scrolls in
timer_counter:          .rs 1  ; This variable is used for timing purposes
;temp1:                  .rs 1  ; General puprose temporary variable

;;;;;;;;;;;;;;;;
;----- first 8k bank of PRG-ROM
; We will stick our sound engine in the first one, which starts at $8000.
    .bank 0
    .org $8000

;    .include "sound_engine.asm"  ; LATER WILL INCLUDE

;;;;;;;;;;;;;;;; GAME CODE ;;;;;;;;;;;;;;;;;;;;;;;;

;----- second 8k bank of PRG-ROM
    .bank 1
    .org $A000

;----- third 8k bank of PRG-ROM
    .bank 2
    .org $C000


;;;;;;;;;;;;;;; RESET ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RESET:
  sei          ; disable IRQs
  cld          ; disable decimal mode
  ldx #$40
  stx $4017    ; disable APU frame IRQ
  ldx #$FF
  txs          ; Set up stack
  inx          ; now X = 0
  stx $2000    ; disable NMI
  stx $2001    ; disable rendering
  stx $4010    ; disable DMC IRQs

  jsr waitForVblank

;; Clear the RAM
.clrmem:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  lda #$FE
  sta $0200, x
  inx
  bne .clrmem

  jsr waitForVblank

;; Load the palettes
  lda $2002
  lda #$3F
  sta $2006
  lda #$00
  sta $2006

  ldy #$00
.palette_loop:
  lda palette_data, y
  sta $2007
  sta palette_buffer, y
  iny
  cpy #$20
  bne .palette_loop

  jsr clear_nametable0
  jsr clear_nametable1
  jsr draw_title_screen

;;;Set some initial ball stats
  lda #INITIAL_BALL_POS_Y
  sta bally

  lda #INITIAL_BALL_POS_P1_X
  sta ballx

;;;Set up paddles
  lda #PADDLE_TOP_LIMIT
  sta paddle1ytop
  sta paddle2ytop

;; Initial game state:
  lda #STATETITLEANIMATION
  sta gamestate

  lda #%10010001   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  sta ppu_control_soft
  sta $2000

  lda #%00011110   ; enable sprites, enable background, no clipping on left side
  sta ppu_mask_soft
  sta $2001

Forever:
;;; Run the game engine here, if we are woken up!!
;;; We will use variable "sleeping", and NMI will set it to 0, so the game engine will run once per frame
  inc sleeping
.loop:
  lda sleeping
  bne .loop

  ;; The code below this line will execute when NMI wakes us up
  jsr safe_read_joypads
  jsr game_engine_run


  jmp Forever ;; Back to sleep

NMI:
  ;; Store the registers in the stack (game engine might need the data stored there)
  pha
  txa
  pha
  tya
  pha

  ;; Update sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014

  ;; Update palettes if needed
  lda need_palette_update
  beq .draw_bg

  lda $2002
  lda #$3F
  sta $2006
  lda #$00
  sta $2006

  tay
  sta need_palette_update

.palette_loop:
  lda palette_buffer, y
  sta $2007
  iny
  cpy #$20
  bne .palette_loop

  ;; Resetting PPU address.
  ;; Dunno why but without it the game dies after palette update
  ;; e.g. when clicking start fort the first time on options screen
  ;; in 1 player mode
  lda $2002
  lda #$20
  sta $2006
  lda #$00
  sta $2006

.draw_bg:
  ;; Draw background if needed
  lda need_draw
  beq .drawing_done
  jsr draw_from_buffer
  lda #$00
  sta need_draw

.drawing_done:
  ;; No scrolling
  ;; -- Need to set scroll after EVERY write to $2006 (PPUADDR) becuase
  ;; -- they share the same internal register -> write to $2006 overwrites $2005 (PPUSCROLL)
  lda h_scroll
  sta $2005

  lda #$00
  sta $2005

.wake_up_game_engine:
  ;; Wake up the the game engine
  lda #$00
  sta sleeping

  ;; Restore the registers
  pla
  tay
  pla
  tax
  pla
  rti

irq:
  rti

;;;;;;;;;;;;;;;; WAIT FOR VBLANK ;;;;;;;;;;;;;;;;;;;;;;;;;;;

waitForVblank:
  lda $2002
  bpl waitForVblank   ;;; BIT 7 os $2002 is 1 when we are in a vblank, 0 if not
  rts

;;;;;;;;;;;;;;;;;;;;;; INCLUDE SUBROUTINES ;;;;;;;;;;;;;;;;;;;;;;;
  .include "ppu_subroutines.asm"
  .include "drawing_subroutines.asm"
  .include "joypad_subroutines.asm"
  .include "game_engine.asm"
  .include "random_numbers.asm"

;----- fourth 8k bank of PRG-ROM
    .bank 3
    .org $E000

;;;;;;;;;;;;;;;;;;;;;; INCLUDE DATA ;;;;;;;;;;;;;;;;;;;;;;;
    .include "graphicData.i"
    .include "game_constants.i"

;;;;;;;;;;;;;;;;;;;;;; VECTORS ;;;;;;;;;;;;;;;;;;;

    .org $FFFA     ;first of the three vectors starts here
    .dw NMI        ;when an NMI happens (once per frame if enabled) the
                   ;processor will jump to the label NMI:
    .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
    .dw irq        ;external interrupt IRQ is not used in this tutorial

;;;;;;;;;;;;;;;;;; CHR ROM ;;;;;;;;;;;;;;;;;;;;;;;
    .bank 4
    .org $0000
    .incbin "pong.chr"
