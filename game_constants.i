;;;;; ANIMATION STUFF
TITLE_SCROLL_SPEED = $02  ;; px per frame for scroll in effect
START_DELAY_FRAMES = $20  ;; number of frames of start delay

;;; WALL POSITIONS

RIGHTWALL      = $F4  ; when ball reaches one of these, bounce or ball out
TOPWALL        = $28
BOTTOMWALL     = $D8
LEFTWALL       = $04

;;; INITIAL VALUES

PADDLE1X               = $08  ; horizontal position for paddles, doesn't move
PADDLE2X               = $F0
PADDLE_TOP_LIMIT       = $2B
PADDLE_BOTTOM_LIMIT    = $BA
PADDLE_WIDTH           = $20

INITIAL_BALL_SPEED_X    = $02
INITIAL_BALL_SPEED_Y    = $02

INITIAL_BALL_POS_Y     = $33
INITIAL_BALL_POS_P1_X  = $10
INITIAL_BALL_POS_P2_X  = $E8

;;; DRAW BUFFER ADDRESS

DRAW_BUFFER      = $0400
DRAW_BUFFER_HIGH =   $04

;;; TARGET SCORES
target_score_option_table:
  .BYTE $02, $03, $04, $05, $06, $07, $08, $09, $0B, $0D, $0F, $11, $13
