;;;;;;;;;;;;;; CONSTANTS FOR THE BUTTONS ;;;;;;;;;;;;;;;;;
BUTTON_A       = %10000000
BUTTON_B       = %01000000
BUTTON_SELECT  = %00100000
BUTTON_START   = %00010000
BUTTON_UP      = %00001000
BUTTON_DOWN    = %00000100
BUTTON_LEFT    = %00000010
BUTTON_RIGHT   = %00000001

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OAM DMA might cause glitches in clock signal while reading joaypads sometimes
;; causing incorrect reading. To avoid this, read twice and compar results. If they differ, start over.
;; more info: https://wiki.nesdev.com/w/index.php/Controller_reading_code#DPCM_Safety_using_OAM_DMA
;;
;; We also use this subroutine to determine which buttons were "freshly" pressed
safe_read_joypads:

  ;; Save the previous controller states
  ;; We need to do it here, because if we do it in the read_joypads subroutine
  ;; it would overwrite the old again on the second read (usually with same value)
  ;; thus making it impossible to determine the newly pressed buttons
  lda joypad1_current
  sta joypad1_old

  lda joypad2_current
  sta joypad2_old

  jsr read_joypads

.reread:
  ;; push the last read values to stack
  lda joypad1_current
  pha
  lda joypad2_current
  pha

  ;; read again
  jsr read_joypads

  ;; first check joy 2 becuase that was pushed last
  pla
  cmp joypad2_current
  bne .reread

  ;; then check the first one
  pla
  cmp joypad1_current
  bne .reread

  ;; now determine which buttons were pressed now
  lda joypad1_old         ;; flip bits with EOR to find which buttons were not pressed last time
  eor #$FF
  and joypad1_current     ;; and with an AND find out which of those is pressed now
  sta joypad1_pressed

  lda joypad2_old
  eor #$FF
  and joypad2_current
  sta joypad2_pressed

  rts

;; This subroutine reads the joypads
;; Don't call it directly, use safe_read_joypads instead
read_joypads:
  ;; in this method using a ring counter
  ;;  it means that we load 01 to the target memory address
  ;;  with each ROL this 1 moves bit to the right
  ;;  after the 8th ROL carry bit will be 1, indicating that we are done
  ;;  since we need to read 8 times



  ;; latch the controllers
  ldx #$01
  stx $4016
  stx joypad2_current
  dex
  stx $4016

  ;; read 8 times
.loop:
  lda $4016
  lsr a                     ; bit0 -> Carry
  rol joypad1_current       ; bit0 <- Carry

  lda $4017
  lsr a
  rol joypad2_current

  bcc .loop

  rts
