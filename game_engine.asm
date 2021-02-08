
;;;;;;;;;;;;;;;;;;;;;;;;; TITLE SCREEN
game_engine_title:
;; Check whether the select button is pressed or not
  lda joypad1_pressed
  and #BUTTON_SELECT
  beq .check_start_btn

  ;; if select button pressed we flip the selected option using an EOR
  lda number_of_players
  eor #$01
  sta number_of_players

  ;; if it 2 players now, we need to move the icon down
  beq .one_p_selected
  lda $0200
  clc
  adc #$10                  ; move 16 px down
  bne .store_icon_pos       ; icon positioned so that y pos will never be 0 (bne cheaper than jmp)

.one_p_selected:
  ;; if it 1 players now, we need to move the icon up
  lda $0200
  sec
  sbc #$10                  ; move 16 px up
.store_icon_pos:
  sta $0200

.check_start_btn:
;; Check whether the start button is pressed or not
  lda joypad1_pressed
  and #BUTTON_START
  beq .done

;; If start button is pressed we draw the game options screen and change game state
  lda #$00      ;; turn everything off except NMI
  sta $2001

  jsr clear_nametable0
  jsr draw_options_screen

  lda #STATEOPTIONS
  sta gamestate

  lda ppu_mask_soft
  sta $2001

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  This subroutine is responsible
;;  for playing the game
game_engine_playing:
;; Move paddles up and down
  jsr move_paddles
;; Release ball if needed
  jsr check_ball_release
;; Move the ball
  jsr move_ball

;; Update sprite data
  jsr game_engine_update_sprites

  rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine moves the paddles
move_paddles:

  ldy #$00

.move_paddle_up:
  ;; if up button pressed and x >= top limit, we move paddle
  lda joypad1_current, y
  and #BUTTON_UP
  beq .move_paddle_down

  ldx paddle1ytop, y
  dex
  dex
  cpx #PADDLE_TOP_LIMIT
  bcc .done_loop               ;; Carry is set if A >= PADDLE_TOP_LIMIT
  stx <paddle1ytop, y          ;; need to force zero page addressing (NESASM)

  ;; if the ball is not released and player has it, we move that as well
  lda ball_released
  bne .done_loop

  ;; Last scorer will be 0 if P1 and 1 if P2 (unlike first version i wrote,
  ;; where it was 0 at beginning, 1 if P1 and 2 if P2)
  cpy lastscorer    ; did the player who's buttons we are checking score last time?
  bne .done_loop    ; if no, we are done

  dec bally
  dec bally         ;; Should never be 0
  bne .done_loop    ;; On worn joypads up and down can be pressed at once. We ignore down in this game if so.

.move_paddle_down:
  ;; if down button pressed and x < bottom limit, we move
  lda joypad1_current, y
  and #BUTTON_DOWN
  beq .done_loop

  ldx paddle1ytop, y
  inx
  inx
  cpx #PADDLE_BOTTOM_LIMIT
  bcs .done_loop
  stx <paddle1ytop, y ;; need to force zero page addressing (NESASM)

  lda ball_released
  bne .done_loop

  cpy lastscorer    ; did the player who's buttons we are checking score last time?
  bne .done_loop

  inc bally
  inc bally

.done_loop:
  ;; If one player mode we are done
  lda number_of_players
  beq .done

  ;; otherwise increase y and do loop once more
  iny
  cpy #$02
  bne .move_paddle_up

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine moves the ball
move_ball:

.move_ball_up:
  lda ballup
  beq .move_ball_down         ;; if ballup = 0, skip this section

  ldy ballspeedy
.ball_up_loop:                ;; decrement ball pos by 1 px at a time, because
  dey                         ;; its not guaranteed that decrementing by ballspeedy will not
  dec bally
  lda bally                 ;; penetrate the top wall
  cmp #TOPWALL
  beq .bounce_down            ;; if we hit the wall, we bounce

  cpy #$00                    ;; if y = 0 we are done with moving up
  bne .ball_up_loop

  beq .move_ball_right        ;; last operation set Z flag, we can use BEQ to jump to sideways movements

.bounce_down:
  lda #$00
  sta ballup

  lda #$01
  sta balldown

  cpy #$00
  bne .ball_down_loop          ;; If we are bouncing in the middle of the loop, we are doing the rest of them
                               ;; movement downwards
  beq .move_ball_right         ;; If movement was completed, we jump to sideways movements

.move_ball_down:
  lda balldown
  beq .move_ball_right         ;; if balldown = 0, skip this section

  ldy ballspeedy

.ball_down_loop:
  dey                         ;; its not guaranteed that incrementing by ballspeedy will not
  inc bally
  lda bally                  ;; penetrate the bottom wall
  cmp #BOTTOMWALL
  beq .bounce_up              ;; if we hit the wall, we bounce

  cpy #$00                    ;; if y = 0 we are done with moving up
  bne .ball_down_loop

  beq .move_ball_right        ;; last operation set Z flag, we can use BEQ to jump to sideways movements

.bounce_up:
  lda #$00
  sta balldown

  lda #$01
  sta ballup

  cpy #$00
  bne .ball_up_loop          ;; If we are bouncing in the middle of the loop, we are doing the rest of them
                             ;; movement downwards

.move_ball_right:
  lda ballright
  beq .move_ball_left ;; if ballright = 0, skip this section

.move_ball_left:
  lda ballleft
  beq .done ;; if ballright = 0, skip this section

  ldy ballspeedx
.ball_left_loop:
  dey
  dec ballx

  lda #PADDLE1X+8
  cmp ballx
  bcc .no_bounce

.nobounce:  

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine bounces the ball from left to right
ball_bounce_left_right:
  lda ballleft
  eor #$01
  sta ballleft

  lda ballright
  eor #$01
  sta ballright
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine bounces the ball up/down
ball_bounce_up_down:
  lda ballup
  eor #$01
  sta ballup

  lda balldown
  eor #$01
  sta balldown
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check paddle1 collosion and if ball is out
;; Retruns in X:
;;  - 0 if no collosion is detected
;;  - 1 if collosion with front part of paddle
;;  - 2 if side collosion detected and ball bounces back
;;  - 3 if side collosion detected and ball bounces out
;;  - 4 if ball is out of play
check_paddle1_collosion:
  ;;;;;; in case using Y in this sub, save it and RESTORE!!!!
  ;;; First, check if ball collided with front part of the paddle
  ldx #$00    ;; Initialize return value as 0

.check_frontal_collosion:
  ;;first check if ball is above the paddle
  lda bally
  clc
  adc #$08                              ;; If Ball y + 8  < paddle y ball is above paddle
  cmp paddle1ytop
  bcc .check_frontal_collosion_done     ;; so definitely no frontal collosion
  beq .side_collosion

  ;; now check if ball is below the paddle
  lda paddle1ytop
  clc
  adc #$20 ;;;; For now we don't consider that paddle length can change
  cmp bally
  bcc .check_frontal_collosion_done
  beq .side_collosion

  ;; Frontal collosion detected
  ldx #$01
  bne .done
.check_frontal_collosion_done:

;;; If no frontal collosion detected and no side collosion
;;; Then the only thing to check is wheteher the ball is out of play
.check_ball_out:
  lda ballx   ;; if 0 ball is out
  bne .done

  ldx #$04
  bne .done

.side_collosion:
  ;; If ball passed further than half of the paddle witdth, it bounces out
  lda ballx
  sec
  sbc #$04
  cmp #PADDLE1X
  bcc .bounce_out

  ldx #$02
  bne .done

.bounce_out:
  ldx #$03

.done:
  rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Works tha same way as paddle 1 collosion check
;; Retruns in X:
;;  - 0 if no collosion is detected
;;  - 1 if collosion with front part of paddle
check_paddle2_collosion:
  ldx #$00    ;; Initialize return value as 0
.check_frontal_collosion:

  ;;first check if ball is above the paddle
  lda bally
  clc
  adc #$08                              ;; If Ball y + 8  < paddle y ball is above paddle
  cmp paddle2ytop
  bcc .check_frontal_collosion_done     ;; so definitely no frontal collosion (before this can check = !!!)

  ;; now check if ball is below the paddle
  lda paddle2ytop
  clc
  adc #$20 ;;;; For now we don't consider that paddle length can change
  cmp bally
  bcc .check_frontal_collosion_done

  ;; If neither is the case, we have frontal collosion
  ldx #$01
  bne .done
.check_frontal_collosion_done:

.done:
;;;;;;;;;;;;;;;;TEST
  ldx #$01
  rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine updates sprites
game_engine_update_sprites:
  ;;Update ball
  lda bally
  sta $0200
  lda ballx
  sta $0203

  ;; Update p1 paddle
  lda paddle1ytop
  sta $0204
  clc
  adc #$08
  sta $0208
  adc #$08
  sta $020C
  adc #$08
  sta $0210

  ;; Update p2 paddle
  lda paddle2ytop
  sta $021C
  clc
  adc #$08
  sta $0220
  adc #$08
  sta $0224
  adc #$08
  sta $0228

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine releases the ball if needed
check_ball_release:
  ;If already released we are done
  lda ball_released
  bne .done

  ;; Check if P1 has the ball
  lda lastscorer
  bne .check_p2

  ;; Check P1 btn A
  lda joypad1_pressed
  and #BUTTON_A
  beq .done

  ;; Release ball
  lda #$01
  sta balldown
  sta ballright
  sta ball_released

  lda #INITIAL_BALL_SPEED_X
  sta ballspeedx

  lda #INITIAL_BALL_SPEED_Y
  sta ballspeedy

  bne .done

.check_p2:
  ;; If one player mode, we are done
  lda number_of_players
  beq .done

  ;; Check P2 btn A
  lda joypad2_pressed
  and #BUTTON_A
  beq .done

  ;; Release ball
  lda #$01
  sta balldown
  sta ballleft
  sta ball_released

  lda #INITIAL_BALL_SPEED_X
  sta ballspeedx

  lda #INITIAL_BALL_SPEED_Y
  sta ballspeedy

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; options screen
game_engine_options:
  lda current_option
  bne .set_paddle_colors

  jsr game_engine_options_winning_score
  jmp .done

.set_paddle_colors:
  jsr game_engine_options_paddle_color

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine is responsoible for the winning score selection
;;; listening only to P1 joy left, right or start.
;;; pressing start brings us to colors options
game_engine_options_winning_score:
  ;;if cpu is opponent we start random number generation
  lda number_of_players
  bne .check_start

  lda #$01
  sta need_update_random

.check_start:
  lda joypad1_pressed
  and #BUTTON_START
  beq .check_right

  ; change the position of pointer arrow
  lda #$60
  sta $0200

  ldx #$01
  stx current_option
  dex
  stx need_update_random

  lda #$03   ;; change arrow color to green
  sta $0206

  ;; clear score1 cuz used it earlier as a temp var
  lda #$00
  sta score1

  jsr set_cpu_paddle_color

  bne .done

.check_right:
  lda joypad1_pressed
  and #BUTTON_RIGHT
  beq .check_left

  ;; Check if we reached max selectable option:
  ldx score_option_selected
  cpx #$0C
  beq .done ;; if yes, we are done

  inx
  stx score_option_selected

  ;; check if we need to add 16 or 20 or 24 to the x position
  cpx #$08
  beq .add20
  bcs .add24

.add_16:
  lda #$10
  bne .add_x_pos

.add20:
  lda #$14
  bne .add_x_pos

.add24:
  lda #$18

.add_x_pos:
  clc
  adc $0207
  sta $0207
  bne .done

.check_left:
  lda joypad1_pressed
  and #BUTTON_LEFT
  beq .done

  ;; Check if we reached min selectable option:
  ldx score_option_selected
  cpx #$00
  beq .done ;; if yes, we are done

  dex
  stx score_option_selected

  ;; check if we need to subtract 16 or 20 or 24 from the x position
  cpx #$07
  beq .subtract20
  bcs .subtract24

.subtract16:
  lda #$10
  bne .subtract_x_pos

.subtract20:
  lda #$14
  bne .subtract_x_pos

.subtract24:
  lda #$18

.subtract_x_pos:
  sta score1 ;not needed yet, so using as a temp variable
  lda $0207
  sec
  sbc score1
  sta $0207
  bne .done

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine is responsible for setting padddle colors
;;; setting paddle colors
;;; p1 and p2 can set color by pressing up or down
;;; when both pressed start, game begins
;;; when cpu is opponent, it choses randomly, ready immediately

game_engine_options_paddle_color:
  ;; check if p1 pressed start already
  lda score1  ;; using this as temporary to save ram
  bne .check_down_p2

  ;;check the down btn
  lda joypad1_pressed
  and #BUTTON_DOWN
  beq .check_up_p1

  ;;check if we reached the last option
  lda player1_color
  cmp #$05
  beq .check_down_p2

  ;; increase option, add 16px to arrow y pos
  inc player1_color
  lda $0208
  clc
  adc #$10
  sta $0208
  jsr update_player1_paddle_palette

.check_up_p1:
  lda joypad1_pressed
  and #BUTTON_UP
  beq .check_start_p1

  ;; check if we reached the first option
  lda player1_color
  cmp #$00
  beq .check_down_p2

  ;; decrease option, subtract 16px from arrow y pos
  dec player1_color
  lda $0208
  sec
  sbc #$10
  sta $208
  jsr update_player1_paddle_palette

.check_start_p1:
  lda joypad1_pressed
  and #BUTTON_START
  beq .check_down_p2

  ;; change arrow color to green
  lda #$03
  sta $020A

  ;; use score1 as a temporary variable to indicate that player is ready
  lda #$01
  sta score1

.check_down_p2
  ;; if 1 player mode, we don't check p2 joy buttons
  lda number_of_players
  beq .check_ready

  ;; check if p2 pressed start already
  lda score2
  bne .check_ready

  ;; check the down button
  lda joypad2_pressed
  and #BUTTON_DOWN
  beq .check_up_p2

  ;;check if we reached the last option
  lda player2_color
  cmp #$05
  beq .done

  ;; increase option, add 16px to arrow y pos
  inc player2_color
  lda $020C
  clc
  adc #$10
  sta $020C
  jsr update_player2_paddle_palette

.check_up_p2:
  lda joypad2_pressed
  and #BUTTON_UP
  beq .check_start_p2

  ;; check if we reached the first option
  lda player2_color
  cmp #$00
  beq .done

  ;; decrease option, subtract 16px from arrow y pos
  dec player2_color
  lda $020C
  sec
  sbc #$10
  sta $20C
  jsr update_player2_paddle_palette

.check_start_p2:
  lda joypad2_pressed
  and #BUTTON_START
  beq .check_ready

  ;; change arrow color to green
  lda #$03
  sta $020E

  ;; use score1 as a temporary variable to indicate that player is ready
  lda #$01
  sta score2

.check_ready:
  lda score1
  and score2  ;; will be 1 if both are 1
  beq .done

  ;; reset the score variables for their intended use
  lda #$00
  sta score1
  sta score2

  ;; set the winning score
  ldy score_option_selected
  lda target_score_option_table, y
  sta winningscore

  lda #$00      ;; turn everything off except NMI
  sta $2001

  jsr clear_nametable0
  jsr clear_sprites

  lda #START_DELAY_FRAMES
  sta timer_counter

  lda #STATESTARTDELAY
  sta gamestate

  lda ppu_mask_soft
  sta $2001

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine sets up the cpu paddle color
;; if 1 player mode, when start pressed after winning score is selected

set_cpu_paddle_color:
  lda number_of_players
  beq .set_cpu_paddle
  ;; if 2 player mode, we set 2nd color for player 2 becuse that is selected by default
  lda #$01
  sta player2_color
  bne .done

.set_cpu_paddle:
  lda random_0_to_5
  sta player2_color

  ; set arrow position
  tay
  lda #$80 ;y position at first option
.position_loop:
  cpy #$00
  beq .store_y_pos
  dey

  clc
  adc #$10
  bne .position_loop

.store_y_pos:
  sta $020C

  lda #$03   ;; change arrow color to green
  sta $020E

  jsr update_player2_paddle_palette

  ;; CPU is ready, use score 2 variable as temp variable to store it
  sta score2

.done
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This subroutine updates player 1 palette data
update_player1_paddle_palette:
  lda player1_color
  asl a
  asl a ;;multiply by 4 cuz each palette data is 4 bytes
  tay

  ldx #$00

.palette_loop:
  lda paddle_color_options, y
  sta palette_buffer+20, x
  inx
  iny
  cpx #$04
  bne .palette_loop

  lda #$01
  sta need_palette_update

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This subroutine updates player 2 palette data
update_player2_paddle_palette:
  lda player2_color
  asl a
  asl a ;;multiply by 4 cuz each palette data is 4 bytes
  tay

  ldx #$00

.palette_loop:
  lda paddle_color_options, y
  sta palette_buffer+24, x
  inx
  iny
  cpx #$04
  bne .palette_loop

  lda #$01
  sta need_palette_update

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine handles the title screen scroll in animation
game_eninge_title_screen_animation:
  ;; Check if start button is pressed. If yes, we finish animation
  lda joypad1_pressed
  and #BUTTON_START
  bne .finish_animation

.do_animation
  lda h_scroll
  clc
  adc #TITLE_SCROLL_SPEED
  sta h_scroll
  bcc .done   ;; h_scroll rolls over animation is done

.finish_animation:
  ;; set 0 horizontal scroll
  lda #$00
  sta h_scroll

  ;; set ppu
  lda #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  sta ppu_control_soft
  sta $2000

  ;; Copy the sprite data to OAM
  ldy #$00
.sprite_loop:
  lda title_screen_sprite_data, y
  sta $0200, y
  iny
  cpy #$04
  bne .sprite_loop

  lda #STATETITLE
  sta gamestate

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine is responsible for delay between option and game screen
;; of the options screen
game_engine_start_delay:
  lda timer_counter
  beq .delay_done

  dec timer_counter
  jmp .done

.delay_done:

  lda #STATEPLAYING
  sta gamestate

  lda #$00      ;; turn everything off except NMI
  sta $2001

  jsr draw_game_screen

  lda ppu_mask_soft
  sta $2001


.done
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine jumps to the correct gamestate subroutine
;; using the jump table
game_engine_run:
  ;; Check if we need random number
  lda need_update_random
  beq .check_game_states
  jsr random_0_to5_update

.check_game_states:
  lda gamestate
  asl a               ; multiply by 2 because pointers are 2 byte long
  tay

  ;; store the required subroutine pointer in jump pointer and uthen se indirect jump
  lda game_states_jump_table, y
  sta jump_pointer

  lda game_states_jump_table+1,y
  sta jump_pointer+1

  jmp [jump_pointer]

;;; POSSIBLE GAME STATES
STATETITLEANIMATION = $00  ; scrolling in title screen
STATETITLE          = $01  ; displaying title screen
STATEOPTIONS        = $02  ; displaying the options_screen
STATESTARTDELAY     = $03  ; adding a little delay between options screen and game start
STATEPLAYING        = $04  ; move paddles/ball, check for collisions
STATEGAMEOVER       = $05  ; displaying game over screen
STATEPAUSED         = $06  ; game is paused
STATEWAITING        = $07  ; waiting before restarting

;;;;;;;;;;; JUMP TABLE FOR GAME STATES
game_states_jump_table:
  .dw game_eninge_title_screen_animation
  .dw game_engine_title
  .dw game_engine_options
  .dw game_engine_start_delay
  .dw game_engine_playing