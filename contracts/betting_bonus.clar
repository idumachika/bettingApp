(define-data-var bonuses (map principal uint))

;; Define a constant for the minimum bet required to qualify for a bonus
(define-constant MIN_BET_AMOUNT 100)

(define-public (add-bonus (user principal) (amount uint))
    (begin
        ;; Check if the user is eligible for a bonus
        (if (>= amount MIN_BET_AMOUNT)
            (let ((current-bonus (var-get bonuses user)))
                (map-set bonuses user (+ current-bonus amount))
                (ok "Bonus added successfully"))
            (err "Bet amount is less than minimum required to earn a bonus"))
    )
)