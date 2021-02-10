;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SPRITE CONSTANTS ;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_PADDLE_TOP         = $01
SPRITE_PADDLE_BOTTOM      = $21
SPRITE_PADDLE_MIDDLE      = $11

SPRITE_POINTER_HORIZONTAL = $00
SPRITE_POINTER_VERTICAL   = $10
SPRITE_BALL               = $20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PALETTES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

palette_data:
  .BYTE $0F,$27,$16,$05,  $0F,$01,$11,$31,  $0F,$05,$16,$26,  $0F,$27,$01,$1A   ;; background palette
  .BYTE $0F,$11,$1A,$31,  $0F,$01,$11,$31,  $0F,$05,$16,$26,  $0F,$19,$19,$19   ;; sprite palette

;;;;;;;;;;;;;;;;;;;;;;;;;;;; TITLE SCREEN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For now keep the original encoding just in case need to revert
title_screen_part1:
  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $0A,  $0A, $20, $20, $0A,  $0A, $0A, $0A, $20 ;row 1
  .BYTE $0A, $20, $20, $20,  $0A, $20, $0A, $0A,  $0A, $0A, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $20,  $20, $0A, $20, $0A,  $20, $20, $0A, $20 ;row 2
  .BYTE $0A, $0A, $20, $20,  $0A, $20, $0A, $20,  $20, $20, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $20,  $20, $0A, $20, $0A,  $20, $20, $0A, $20 ; ;row 3
  .BYTE $0A, $0A, $20, $20,  $0A, $20, $0A, $20,  $20, $20, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $20,  $20, $0A, $20, $0A,  $20, $20, $0A, $20 ;row 4
  .BYTE $0A, $20, $0A, $20,  $0A, $20, $0A, $20,  $20, $20, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $0A,  $0A, $20, $20, $0A,  $20, $20, $0A, $20  ;row 5
  .BYTE $0A, $20, $0A, $20,  $0A, $20, $0A, $20,  $0A, $0A, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $20,  $20, $20, $20, $0A,  $20, $20, $0A, $20 ;row 6
  .BYTE $0A, $20, $20, $0A,  $0A, $20, $0A, $20,  $20, $0A, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $20,  $20, $20, $20, $0A,  $20, $20, $0A, $20 ;row 7
  .BYTE $0A, $20, $20, $0A,  $0A, $20, $0A, $20,  $20, $0A, $20, $20,  $20, $20, $20, $20

  .BYTE $20, $20, $20, $20,  $20, $20, $0A, $20,  $20, $20, $20, $0A,  $0A, $0A, $0A, $20 ;row 8
  .BYTE $0A, $20, $20, $20,  $0A, $20, $0A, $0A,  $0A, $0A, $20, $20,  $20, $20, $20, $20

title_screen_part1_rle:
  .BYTE $03, $0A,  $02, $20, $04, $0A,  $01, $20, $01, $0A,  $03, $20, $01, $0A ;Row 1
  .BYTE $01, $20, $04, $0A,  $06, $20

  .BYTE $06, $20, $01, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A,  $02, $20, $01, $0A ;Row 2
  .BYTE $01, $20, $02, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A,  $09, $20

  .BYTE $06, $20, $01, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A,  $02, $20, $01, $0A ;Row 3
  .BYTE $01, $20, $02, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A,  $01, $20, $08, $20

  .BYTE $06, $20, $01, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A,  $02, $20, $01, $0A ;Row 4
  .BYTE $01, $20, $01, $0A,  $01, $20, $01, $0A,  $01, $20, $01, $0A,  $01, $20, $01, $0A
  .BYTE $09, $20

  .BYTE $06, $20, $03, $0A,  $02, $20, $01, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A ;Row 5
  .BYTE $01, $20, $01, $0A,  $01, $20, $01, $0A,  $01, $20, $01, $0A,  $01, $20, $02, $0A
  .BYTE $06, $20

  .BYTE $06, $20, $01, $0A,  $04, $20, $01, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A ;Row6
  .BYTE $02, $20, $02, $0A,  $01, $20, $01, $0A,  $02, $20, $01, $0A,  $06, $20

  .BYTE $06, $20, $01, $0A,  $04, $20, $01, $0A,  $02, $20, $01, $0A,  $01, $20, $01, $0A ;Row 7
  .BYTE $02, $20, $02, $0A,  $01, $20, $01, $0A,  $02, $20, $01, $0A,  $06, $20

  .BYTE $06, $20, $01, $0A,  $04, $20, $04, $0A,  $01, $20, $01, $0A,  $03, $20, $01, $0A ;Row 8
  .BYTE $01, $20, $04, $0A,  $06, $20

;;;;;;;; STRINGS
;;;;;;;;;;;; TITLE SCREEN

TITLE_START_ADDR_HI     = $20
TITLE_START_ADDR_LO     = $A6
TITLE_LENGTH            = $F4

PLAYER_1_START_HI       = $22
PLAYER_1_START_LO       = $8F

PLAYER_2_START_HI       = $22
PLAYER_2_START_LO       = $CF

PL_NUM_1_HI             = $22
PL_NUM_1_LO             = $8D

PLAYER_LENGTH           = $06
PLAYERS_LENGTH          = $07

string_player:
  .BYTE "PLAYER"

string_players:
  .BYTE "PLAYERS"

num_col_player_numbers:
  .BYTE $01, $20, $02

title_screen_sprite_data:
  .BYTE $A0, SPRITE_BALL, $00, $58

;;;;;;;;;;;;;;;; OPTION SCREEN
string_game_settings:
  .BYTE $12,  $13, $13, $13, $13,  $13, $13, $13, $20
  .BYTE "GAME  OPTIONS"
  .BYTE $20,  $13, $13, $13, $13,  $13, $13, $13, $13, $14

string_winning_score:
  .BYTE "WINNING SCORE"

string_score_options:
  .BYTE $02, $20, $03, $20, $04, $20, $05, $20, $06, $20, $07, $20, $08, $20, $09, $20
  .BYTE $01, $01, $20, $01, $03, $20, $01, $05, $20, $01, $07, $20, $01, $09

string_paddle_colors:
  .BYTE "PADDLE COLORS"

string_blue:
  .BYTE "BLUE"

string_red:
  .BYTE "RED"

string_green:
  .BYTE "GREEN"

string_purple:
  .BYTE "PURPLE"

string_pink:
  .BYTE "PINK"

string_orange:
  .BYTE "ORANGE"

string_cpu:
  .BYTE "CPU"

option_screen_sprite_data:
  .BYTE $30, SPRITE_POINTER_HORIZONTAL, $00, $3E
  .BYTE $40, SPRITE_POINTER_VERTICAL, $00, $08
  .BYTE $80, SPRITE_POINTER_HORIZONTAL, $00, $1E
  .BYTE $90, SPRITE_POINTER_HORIZONTAL, $00, $9E

  .BYTE $90, SPRITE_PADDLE_TOP, $01, $60
  .BYTE $98, SPRITE_PADDLE_MIDDLE, $01, $60
  .BYTE $A0, SPRITE_PADDLE_MIDDLE, $01, $60
  .BYTE $A8, SPRITE_PADDLE_BOTTOM, $01, $60

  .BYTE $90, SPRITE_PADDLE_TOP, $02, $E0
  .BYTE $98, SPRITE_PADDLE_MIDDLE, $02, $E0
  .BYTE $A0, SPRITE_PADDLE_MIDDLE, $02, $E0
  .BYTE $A8, SPRITE_PADDLE_BOTTOM, $02, $E0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GAME SCREEN
string_score:
  .BYTE "SCORE"

string_target:
  .BYTE "TARGET"
  .BYTE $5b ; :(colon)

game_screen_sprite_data:
  .BYTE INITIAL_BALL_POS_Y, SPRITE_BALL, $00, INITIAL_BALL_POS_P1_X  ; Ball

  .BYTE PADDLE_TOP_LIMIT,    SPRITE_PADDLE_TOP,    $01, PADDLE1X     ; P1 paddle
  .BYTE PADDLE_TOP_LIMIT+8,  SPRITE_PADDLE_MIDDLE, $01, PADDLE1X
  .BYTE PADDLE_TOP_LIMIT+16, SPRITE_PADDLE_MIDDLE, $01, PADDLE1X
  .BYTE PADDLE_TOP_LIMIT+24, SPRITE_PADDLE_BOTTOM, $01, PADDLE1X
  .BYTE $FE, $FE, $FE, $FE                                          ; Reserve 2 sprites if
  .BYTE $FE, $FE, $FE, $FE                                          ; player picks up power up

  .BYTE PADDLE_TOP_LIMIT,    SPRITE_PADDLE_TOP,    $02, PADDLE2X     ; P1 paddle
  .BYTE PADDLE_TOP_LIMIT+8,  SPRITE_PADDLE_MIDDLE, $02, PADDLE2X
  .BYTE PADDLE_TOP_LIMIT+16, SPRITE_PADDLE_MIDDLE, $02, PADDLE2X
  .BYTE PADDLE_TOP_LIMIT+24, SPRITE_PADDLE_BOTTOM, $02, PADDLE2X
  .BYTE $FE, $FE, $FE, $FE                                          ; Reserve 2 sprites if
  .BYTE $FE, $FE, $FE, $FE                                          ; player picks up power up

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game over screen:
string_game_over:
  .BYTE "GAME OVER", $5D ;Exclamation_mark

string_wins:
  .BYTE "WINS"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pause
string_pause:
  .BYTE "PAUSE"

;;;;;; PADDLE PALLETES
paddle_color_options:
  .BYTE $0F,$01,$11,$31  ; blue
  .BYTE $0F,$05,$16,$26  ; red
  .BYTE $0F,$09,$19,$2A  ; green
  .BYTE $0F,$03,$13,$23  ; purple
  .BYTE $0F,$14,$24,$35  ; pink
  .BYTE $0F,$26,$27,$37  ; orange
