;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate pseudo random number between 0 to 5

;; choice will depend on when the user presses the start button
random_0_to5_update:
  inc random_0_to_5
  lda random_0_to_5
  cmp #$06      ;; if 6 go back to 0
  bne .done

  lda #$00
  sta random_0_to_5
.done
  rts
