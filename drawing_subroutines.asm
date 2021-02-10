draw_title_screen:

;; Draw the title
  lda #TITLE_LENGTH
  sta DRAW_BUFFER

  lda #TITLE_START_ADDR_HI
  sta DRAW_BUFFER+1

  lda #TITLE_START_ADDR_LO
  sta DRAW_BUFFER+2

  lda #%00000110
  sta DRAW_BUFFER+3

  lda #LOW(title_screen_part1_rle)
  sta DRAW_BUFFER+4

  lda #HIGH(title_screen_part1_rle)
  sta DRAW_BUFFER+5

;; Draw the numbers
  lda #$03
  sta DRAW_BUFFER+6

  lda #PL_NUM_1_HI
  sta DRAW_BUFFER+7

  lda #PL_NUM_1_LO
  sta DRAW_BUFFER+8

  lda #%00000011
  sta DRAW_BUFFER+9

  lda #LOW(num_col_player_numbers)
  sta DRAW_BUFFER+10

  lda #HIGH(num_col_player_numbers)
  sta DRAW_BUFFER+11

  ;; Draw 1 and 2 player
  ; 1 st player
  lda #PLAYER_LENGTH
  sta DRAW_BUFFER+12

  lda #PLAYER_1_START_HI
  sta DRAW_BUFFER+13

  lda #PLAYER_1_START_LO
  sta DRAW_BUFFER+14

  lda #%00000010
  sta DRAW_BUFFER+15

  lda #LOW(string_player)
  sta DRAW_BUFFER+16

  lda #HIGH(string_player)
  sta DRAW_BUFFER+17

  ; 2 nd player
  lda #PLAYERS_LENGTH
  sta DRAW_BUFFER+18

  lda #PLAYER_2_START_HI
  sta DRAW_BUFFER+19

  lda #PLAYER_2_START_LO
  sta DRAW_BUFFER+20

  lda #%00000010
  sta DRAW_BUFFER+21

  lda #LOW(string_players)
  sta DRAW_BUFFER+22

  lda #HIGH(string_players)
  sta DRAW_BUFFER+23

  lda #$00
  sta DRAW_BUFFER+24

  jsr draw_from_buffer

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This method draws the options screen
draw_options_screen:
;;game settings
  lda #$20
  sta DRAW_BUFFER

  lda #$20
  sta DRAW_BUFFER+1

  lda #$60
  sta DRAW_BUFFER+2

  lda #%00000010
  sta DRAW_BUFFER+3

  lda #LOW(string_game_settings)
  sta DRAW_BUFFER+4

  lda #HIGH(string_game_settings)
  sta DRAW_BUFFER+5

;;winning score
  lda #$0D
  sta DRAW_BUFFER+6

  lda #$20
  sta DRAW_BUFFER+7

  lda #$C9
  sta DRAW_BUFFER+8

  lda #%00000010
  sta DRAW_BUFFER+9

  lda #LOW(string_winning_score)
  sta DRAW_BUFFER+10

  lda #HIGH(string_winning_score)
  sta DRAW_BUFFER+11

;;score options
  lda #$1E
  sta DRAW_BUFFER+12

  lda #$21
  sta DRAW_BUFFER+13

  lda #$21
  sta DRAW_BUFFER+14

  lda #%00000010
  sta DRAW_BUFFER+15

  lda #LOW(string_score_options)
  sta DRAW_BUFFER+16

  lda #HIGH(string_score_options)
  sta DRAW_BUFFER+17

;;paddle colors
  lda #$0D
  sta DRAW_BUFFER+18

  lda #$21
  sta DRAW_BUFFER+19

  lda #$89
  sta DRAW_BUFFER+20

  lda #%00000010
  sta DRAW_BUFFER+21

  lda #LOW(string_paddle_colors)
  sta DRAW_BUFFER+22

  lda #HIGH(string_paddle_colors)
  sta DRAW_BUFFER+23

;; Player 1
  lda #$06
  sta DRAW_BUFFER+24

  lda #$21
  sta DRAW_BUFFER+25

  lda #$C4
  sta DRAW_BUFFER+26

  lda #%00000010
  sta DRAW_BUFFER+27

  lda #LOW(string_player)
  sta DRAW_BUFFER+28

  lda #HIGH(string_player)
  sta DRAW_BUFFER+29
;1
  lda #$01
  sta DRAW_BUFFER+30

  lda #$21
  sta DRAW_BUFFER+31

  lda #$CB
  sta DRAW_BUFFER+32

  lda #%00000000
  sta DRAW_BUFFER+33

  lda #$01
  sta DRAW_BUFFER+34

;; Check if we need to write player 2 or cpu?
  lda number_of_players
  beq .write_cpu

.write_player2:
;; Player 2
  lda #$06
  sta DRAW_BUFFER+35

  lda #$21
  sta DRAW_BUFFER+36

  lda #$D4
  sta DRAW_BUFFER+37

  lda #%00000010
  sta DRAW_BUFFER+38

  lda #LOW(string_player)
  sta DRAW_BUFFER+39

  lda #HIGH(string_player)
  sta DRAW_BUFFER+40
;2
  lda #$01
  sta DRAW_BUFFER+41

  lda #$21
  sta DRAW_BUFFER+42

  lda #$DB
  sta DRAW_BUFFER+43

  lda #%00000000
  sta DRAW_BUFFER+44

  lda #$02
  sta DRAW_BUFFER+45

  jmp .write_colors

.write_cpu:
  lda #$03
  sta DRAW_BUFFER+35

  lda #$21
  sta DRAW_BUFFER+36

  lda #$D6
  sta DRAW_BUFFER+37

  lda #%00000010
  sta DRAW_BUFFER+38

  lda #LOW(string_cpu)
  sta DRAW_BUFFER+39

  lda #HIGH(string_cpu)
  sta DRAW_BUFFER+40

  ;placeholder -> keep buffer same size as when writing P2
  lda #$01
  sta DRAW_BUFFER+41

  lda #$21
  sta DRAW_BUFFER+42

  lda #$DB
  sta DRAW_BUFFER+43

  lda #%00000000
  sta DRAW_BUFFER+44

  lda #$20
  sta DRAW_BUFFER+45

.write_colors:

;blue 1
  lda #$04
  sta DRAW_BUFFER+46

  lda #$22
  sta DRAW_BUFFER+47

  lda #$05
  sta DRAW_BUFFER+48

  lda #%00000010
  sta DRAW_BUFFER+49

  lda #LOW(string_blue)
  sta DRAW_BUFFER+50

  lda #HIGH(string_blue)
  sta DRAW_BUFFER+51

;blue 2
  lda #$04
  sta DRAW_BUFFER+52

  lda #$22
  sta DRAW_BUFFER+53

  lda #$15
  sta DRAW_BUFFER+54

  lda #%00000010
  sta DRAW_BUFFER+55

  lda #LOW(string_blue)
  sta DRAW_BUFFER+56

  lda #HIGH(string_blue)
  sta DRAW_BUFFER+57

;red 1
  lda #$03
  sta DRAW_BUFFER+58

  lda #$22
  sta DRAW_BUFFER+59

  lda #$45
  sta DRAW_BUFFER+60

  lda #%00000010
  sta DRAW_BUFFER+61

  lda #LOW(string_red)
  sta DRAW_BUFFER+62

  lda #HIGH(string_red)
  sta DRAW_BUFFER+63

;red 2
  lda #$03
  sta DRAW_BUFFER+64

  lda #$22
  sta DRAW_BUFFER+65

  lda #$55
  sta DRAW_BUFFER+66

  lda #%00000010
  sta DRAW_BUFFER+67

  lda #LOW(string_red)
  sta DRAW_BUFFER+68

  lda #HIGH(string_red)
  sta DRAW_BUFFER+69

;green 1
  lda #$05
  sta DRAW_BUFFER+70

  lda #$22
  sta DRAW_BUFFER+71

  lda #$85
  sta DRAW_BUFFER+72

  lda #%00000010
  sta DRAW_BUFFER+73

  lda #LOW(string_green)
  sta DRAW_BUFFER+74

  lda #HIGH(string_green)
  sta DRAW_BUFFER+75

;green2
  lda #$05
  sta DRAW_BUFFER+76

  lda #$22
  sta DRAW_BUFFER+77

  lda #$95
  sta DRAW_BUFFER+78

  lda #%00000010
  sta DRAW_BUFFER+79

  lda #LOW(string_green)
  sta DRAW_BUFFER+80

  lda #HIGH(string_green)
  sta DRAW_BUFFER+81

;purple 1
  lda #$06
  sta DRAW_BUFFER+82

  lda #$22
  sta DRAW_BUFFER+83

  lda #$C5
  sta DRAW_BUFFER+84

  lda #%00000010
  sta DRAW_BUFFER+85

  lda #LOW(string_purple)
  sta DRAW_BUFFER+86

  lda #HIGH(string_purple)
  sta DRAW_BUFFER+87

;purple 2
  lda #$06
  sta DRAW_BUFFER+88

  lda #$22
  sta DRAW_BUFFER+89

  lda #$D5
  sta DRAW_BUFFER+90

  lda #%00000010
  sta DRAW_BUFFER+91

  lda #LOW(string_purple)
  sta DRAW_BUFFER+92

  lda #HIGH(string_purple)
  sta DRAW_BUFFER+93

;pink 1
  lda #$04
  sta DRAW_BUFFER+94

  lda #$23
  sta DRAW_BUFFER+95

  lda #$05
  sta DRAW_BUFFER+96

  lda #%00000010
  sta DRAW_BUFFER+97

  lda #LOW(string_pink)
  sta DRAW_BUFFER+98

  lda #HIGH(string_pink)
  sta DRAW_BUFFER+99

;pink 2
  lda #$04
  sta DRAW_BUFFER+100

  lda #$23
  sta DRAW_BUFFER+101

  lda #$15
  sta DRAW_BUFFER+102

  lda #%00000010
  sta DRAW_BUFFER+103

  lda #LOW(string_pink)
  sta DRAW_BUFFER+104

  lda #HIGH(string_pink)
  sta DRAW_BUFFER+105

;orange 1
  lda #$06
  sta DRAW_BUFFER+106

  lda #$23
  sta DRAW_BUFFER+107

  lda #$45
  sta DRAW_BUFFER+108

  lda #%00000010
  sta DRAW_BUFFER+109

  lda #LOW(string_orange)
  sta DRAW_BUFFER+110

  lda #HIGH(string_orange)
  sta DRAW_BUFFER+111

;orange 2
  lda #$06
  sta DRAW_BUFFER+112

  lda #$23
  sta DRAW_BUFFER+113

  lda #$55
  sta DRAW_BUFFER+114

  lda #%00000010
  sta DRAW_BUFFER+115

  lda #LOW(string_orange)
  sta DRAW_BUFFER+116

  lda #HIGH(string_orange)
  sta DRAW_BUFFER+117

;; side lines
;; left
  lda #$17
  sta DRAW_BUFFER+118

  lda #$20
  sta DRAW_BUFFER+119

  lda #$80
  sta DRAW_BUFFER+120

  lda #%00000101
  sta DRAW_BUFFER+121

  lda #$06
  sta DRAW_BUFFER+122

  lda #$23
  sta DRAW_BUFFER+123

  lda #$01
  sta DRAW_BUFFER+124

  lda #$22
  sta DRAW_BUFFER+125

  lda #$10
  sta DRAW_BUFFER+126

  lda #$23
  sta DRAW_BUFFER+127

;;right
  lda #$17
  sta DRAW_BUFFER+128

  lda #$20
  sta DRAW_BUFFER+129

  lda #$9F
  sta DRAW_BUFFER+130

  lda #%00000101
  sta DRAW_BUFFER+131

  lda #$06
  sta DRAW_BUFFER+132

  lda #$33
  sta DRAW_BUFFER+133

  lda #$01
  sta DRAW_BUFFER+134

  lda #$24
  sta DRAW_BUFFER+135

  lda #$10
  sta DRAW_BUFFER+136

  lda #$33
  sta DRAW_BUFFER+137

;;bottom line
  lda #$20
  sta DRAW_BUFFER+138

  lda #$23
  sta DRAW_BUFFER+139

  lda #$60
  sta DRAW_BUFFER+140

  lda #%00000100
  sta DRAW_BUFFER+141

  lda #$01
  sta DRAW_BUFFER+142

  lda #$32
  sta DRAW_BUFFER+143

  lda #$1E
  sta DRAW_BUFFER+144

  lda #$13
  sta DRAW_BUFFER+145

  lda #$01
  sta DRAW_BUFFER+146

  lda #$34
  sta DRAW_BUFFER+147

;; middle line
  lda #$1E
  sta DRAW_BUFFER+148

  lda #$21
  sta DRAW_BUFFER+149

  lda #$41
  sta DRAW_BUFFER+150

  lda #%00000100
  sta DRAW_BUFFER+151

  lda #$1E
  sta DRAW_BUFFER+152

  lda #$13
  sta DRAW_BUFFER+153

;; END OF BUFFER
  lda #$00
  sta DRAW_BUFFER+154
  jsr draw_from_buffer

  ;; Copy the sprite data to OAM
  ldy #$00
.sprite_loop:
  lda option_screen_sprite_data, y
  sta $0200, y
  iny
  cpy #$30
  bne .sprite_loop

; NO scroll
  lda #$00
  sta $2005
  sta $2005

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine draws the game SCREEN
draw_game_screen:
  lda #$80
  sta DRAW_BUFFER

  lda #$20
  sta DRAW_BUFFER+1

  lda #$20
  sta DRAW_BUFFER+2

  lda #%00000100
  sta DRAW_BUFFER+3

;; Line 1
  ;; Left corner
  lda #$01
  sta DRAW_BUFFER+4

  lda #$16
  sta DRAW_BUFFER+5

  ;9 pc top
  lda #$09
  sta DRAW_BUFFER+6

  lda #$17
  sta DRAW_BUFFER+7

  ;1 pc cross
  lda #$01
  sta DRAW_BUFFER+8

  lda #$19
  sta DRAW_BUFFER+9

  ;10 pc top
  lda #$0A
  sta DRAW_BUFFER+10

  lda #$17
  sta DRAW_BUFFER+11

  ;1 pc cross
  lda #$01
  sta DRAW_BUFFER+12

  lda #$19
  sta DRAW_BUFFER+13

  ;9 pc top
  lda #$09
  sta DRAW_BUFFER+14

  lda #$17
  sta DRAW_BUFFER+15

  ;right corner
  lda #$01
  sta DRAW_BUFFER+16

  lda #$18
  sta DRAW_BUFFER+17

;Line 2
  ;left side
  lda #$01
  sta DRAW_BUFFER+18

  lda #$26
  sta DRAW_BUFFER+19

  ; 9 empty
  lda #$09
  sta DRAW_BUFFER+20

  lda #$20
  sta DRAW_BUFFER+21

  ; 1 pc down
  lda #$01
  sta DRAW_BUFFER+22

  lda #$29
  sta DRAW_BUFFER+23

  ;10 empty
  lda #$0A
  sta DRAW_BUFFER+24

  lda #$20
  sta DRAW_BUFFER+25

  ; 1 down
  lda #$01
  sta DRAW_BUFFER+26

  lda #$29
  sta DRAW_BUFFER+27

  ; 9 empty
  lda #$09
  sta DRAW_BUFFER+28

  lda #$20
  sta DRAW_BUFFER+29

  ; right side
  lda #$01
  sta DRAW_BUFFER+30

  lda #$28
  sta DRAW_BUFFER+31

;Line 3
  ;left side
  lda #$01
  sta DRAW_BUFFER+32

  lda #$26
  sta DRAW_BUFFER+33

  ; 9 empty
  lda #$09
  sta DRAW_BUFFER+34

  lda #$20
  sta DRAW_BUFFER+35

  ; 1 pc down
  lda #$01
  sta DRAW_BUFFER+36

  lda #$29
  sta DRAW_BUFFER+37

  ;10 empty
  lda #$0A
  sta DRAW_BUFFER+38

  lda #$20
  sta DRAW_BUFFER+39

  ; 1 down
  lda #$01
  sta DRAW_BUFFER+40

  lda #$29
  sta DRAW_BUFFER+41

  ; 9 empty
  lda #$09
  sta DRAW_BUFFER+42

  lda #$20
  sta DRAW_BUFFER+43

  ; right side
  lda #$01
  sta DRAW_BUFFER+44

  lda #$28
  sta DRAW_BUFFER+45

;; Line 4
  ;; Left corner
  lda #$01
  sta DRAW_BUFFER+46

  lda #$36
  sta DRAW_BUFFER+47

  ;9 pc btm
  lda #$09
  sta DRAW_BUFFER+48

  lda #$37
  sta DRAW_BUFFER+49

  ;1 pc cross
  lda #$01
  sta DRAW_BUFFER+50

  lda #$39
  sta DRAW_BUFFER+51

  ;10 pc top
  lda #$0A
  sta DRAW_BUFFER+52

  lda #$37
  sta DRAW_BUFFER+53

  ;1 pc cross
  lda #$01
  sta DRAW_BUFFER+54

  lda #$39
  sta DRAW_BUFFER+55

  ;9 pc btm
  lda #$09
  sta DRAW_BUFFER+56

  lda #$37
  sta DRAW_BUFFER+57

  ;right corner
  lda #$01
  sta DRAW_BUFFER+58

  lda #$38
  sta DRAW_BUFFER+59

  ;; bottom line
  lda #$20
  sta DRAW_BUFFER+60

  lda #$23
  sta DRAW_BUFFER+61

  lda #$80
  sta DRAW_BUFFER+62

  lda #%00000100
  sta DRAW_BUFFER+63

  ;; Left corner
  lda #$20
  sta DRAW_BUFFER+64

  lda #$17
  sta DRAW_BUFFER+65

;; Score
  lda #$05
  sta DRAW_BUFFER+66

  lda #$20
  sta DRAW_BUFFER+67

  lda #$4D
  sta DRAW_BUFFER+68

  lda #%00000010
  sta DRAW_BUFFER+69

  lda #LOW(string_score)
  sta DRAW_BUFFER+70

  lda #HIGH(string_score)
  sta DRAW_BUFFER+71

;; Target
  lda #$07
  sta DRAW_BUFFER+72

  lda #$20
  sta DRAW_BUFFER+73

  lda #$6B
  sta DRAW_BUFFER+74

  lda #%00000010
  sta DRAW_BUFFER+75

  lda #LOW(string_target)
  sta DRAW_BUFFER+76

  lda #HIGH(string_target)
  sta DRAW_BUFFER+77

;; Target score
  lda #$02
  sta DRAW_BUFFER+78

  lda #$20
  sta DRAW_BUFFER+79

  lda #$73
  sta DRAW_BUFFER+80

  lda #%00000000
  sta DRAW_BUFFER+81

;; get the digits
  lda winningscore
  jsr get_score_digits

;; store the digits
  stx DRAW_BUFFER+82
  sty DRAW_BUFFER+83

;; p1 score
  lda #$02
  sta DRAW_BUFFER+84

  lda #$20
  sta DRAW_BUFFER+85

  lda #$44
  sta DRAW_BUFFER+86

  lda #%00000000
  sta DRAW_BUFFER+87

  lda #$00
  sta DRAW_BUFFER+88
  sta DRAW_BUFFER+89

;; p2 score
  lda #$02
  sta DRAW_BUFFER+90

  lda #$20
  sta DRAW_BUFFER+91

  lda #$5A
  sta DRAW_BUFFER+92

  lda #%00000000
  sta DRAW_BUFFER+93

  lda #$00
  sta DRAW_BUFFER+94
  sta DRAW_BUFFER+95

;; end of buffer
  lda #$00
  sta DRAW_BUFFER+96

  jsr draw_from_buffer

;; set up sprites

  ldy #$00
.sprite_loop:
  lda game_screen_sprite_data, y
  sta $0200, y
  iny
  cpy #$34
  bne .sprite_loop

  rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine draws game over screen
draw_game_over_screen:
  jsr clear_screen

;Game over
  lda #$0A
  sta DRAW_BUFFER

  lda #$21
  sta DRAW_BUFFER+1

  lda #$AB
  sta DRAW_BUFFER+2

  lda #%00000010
  sta DRAW_BUFFER+3

  lda #LOW(string_game_over)
  sta DRAW_BUFFER+4

  lda #HIGH(string_game_over)
  sta DRAW_BUFFER+5

; Player
  lda #$06
  sta DRAW_BUFFER+6

  lda #$21
  sta DRAW_BUFFER+7

  lda #$E9
  sta DRAW_BUFFER+8

  lda #%00000010
  sta DRAW_BUFFER+9

  lda #LOW(string_player)
  sta DRAW_BUFFER+10

  lda #HIGH(string_player)
  sta DRAW_BUFFER+11

;; Which player?
  lda #$01
  sta DRAW_BUFFER+12

  lda #$21
  sta DRAW_BUFFER+13

  lda #$F0
  sta DRAW_BUFFER+14

  lda #%00000000
  sta DRAW_BUFFER+15

  inc lastscorer  ;; 0 if p1 -> add 1 -> 1 its the position of number 1 in pattern table
  lda lastscorer
  sta DRAW_BUFFER+16

; Wins
  lda #$04
  sta DRAW_BUFFER+17

  lda #$21
  sta DRAW_BUFFER+18

  lda #$F2
  sta DRAW_BUFFER+19

  lda #%00000010
  sta DRAW_BUFFER+20

  lda #LOW(string_wins)
  sta DRAW_BUFFER+21

  lda #HIGH(string_wins)
  sta DRAW_BUFFER+22

;; Exclamation_mark
  lda #$01
  sta DRAW_BUFFER+23

  lda #$21
  sta DRAW_BUFFER+24

  lda #$F6
  sta DRAW_BUFFER+25

  lda #%00000000
  sta DRAW_BUFFER+26

  lda #$5D
  sta DRAW_BUFFER+27

; Wins
  lda #$05
  sta DRAW_BUFFER+28

  lda #$22
  sta DRAW_BUFFER+29

  lda #$29
  sta DRAW_BUFFER+30

  lda #%00000010
  sta DRAW_BUFFER+31

  lda #LOW(string_score)
  sta DRAW_BUFFER+32

  lda #HIGH(string_score)
  sta DRAW_BUFFER+33

;; : xx - xx
  lda #$09
  sta DRAW_BUFFER+34

  lda #$22
  sta DRAW_BUFFER+35

  lda #$2E
  sta DRAW_BUFFER+36

  lda #%00000000
  sta DRAW_BUFFER+37

  lda #$5B                  ;colon
  sta DRAW_BUFFER+38

  lda #$20                  ;space
  sta DRAW_BUFFER+39

  lda score1
  jsr get_score_digits
  stx DRAW_BUFFER+40
  sty DRAW_BUFFER+41

  lda #$20                  ;space
  sta DRAW_BUFFER+42

  lda #$5C                  ;dash
  sta DRAW_BUFFER+43

  lda #$20                  ;space
  sta DRAW_BUFFER+44

  lda score2
  jsr get_score_digits
  stx DRAW_BUFFER+45
  sty DRAW_BUFFER+46

;; End of buffer
  lda #$00
  sta DRAW_BUFFER+47

  jsr draw_from_buffer

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw Pause
draw_pause:
; Wins
  lda #$06
  sta DRAW_BUFFER

  lda #$21
  sta DRAW_BUFFER+1

  lda #$EE
  sta DRAW_BUFFER+2

  lda #%00000010
  sta DRAW_BUFFER+3

  lda #LOW(string_pause)
  sta DRAW_BUFFER+4

  lda #HIGH(string_pause)
  sta DRAW_BUFFER+5

  ;; End of buffer
  lda #$00
  sta DRAW_BUFFER+6

  jsr draw_from_buffer

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clear Pause
clear_pause:
; Wins
  lda #$06
  sta DRAW_BUFFER

  lda #$21
  sta DRAW_BUFFER+1

  lda #$EE
  sta DRAW_BUFFER+2

  lda #%00000100
  sta DRAW_BUFFER+3

  lda #$06
  sta DRAW_BUFFER+4

  lda #$20
  sta DRAW_BUFFER+5

  ;; End of buffer
  lda #$00
  sta DRAW_BUFFER+6

  jsr draw_from_buffer

  rts
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This method displays a score
;; expects:
;;  -- in A: the score to display (max 19)
;;
;; returns:
;;  -- in X: the first digit
;;  -- in Y: the second digit

get_score_digits:
  ;; Check if A is equal to or grater than 10
  cmp #$0A
  bcs .greater_than_10

  ;;if less than 10 we put 0 to x and a to y
  tay
  ldx #$00
  beq .done   ;; cheaper than jmp

.greater_than_10:
  ;; get second digit
  sec
  sbc #$0A
  tay

  ;; max score can be 19 in this game, so in this case, first digit is always 1
  ldx #$01

.done:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine clears nametable 0
clear_nametable0:
  lda #$00
  sta ppu_temp1
  jsr clear_screen
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine clears nametable 1
clear_nametable1:
  lda #$01
  sta ppu_temp1
  jsr clear_screen
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This method clears the screen
;; expects:
;;  - in ppu_temp1: the which nametable to clear
;;    - 0 for namteble 0, etc...
clear_screen:
  lda $2002

;; multiply nametable number by 4, cuz each nametable takes up $400 bytes
  lda ppu_temp1
  asl a
  asl a
  sta ppu_temp1

;; add offset to $20
  clc
  adc #$20

;; finally set ppu address
  sta $2006
  lda #$00
  sta $2006

;; Clear background
  ldx #$00
  ldy #$00
  lda #$20

.bg_loop:
  sta $2007
  inx
  bne .bg_loop
  iny
  cpy #$04
  bne .bg_loop

;;Clear attribute table
  lda $2002

;; add offset to $23
  lda ppu_temp1

  clc
  adc #$23

;; set ppu address
  sta $2006
  lda #$C0
  sta $2006

  lda #$00
  ldx #$40

.attribute_loop:
  sta $2007
  dex
  bne .attribute_loop

  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This subroutine clears sprites
clear_sprites:
  lda #$FE
  ldx #$00
.loop:
  sta $0200, x
  inx
  bne .loop

  rts
