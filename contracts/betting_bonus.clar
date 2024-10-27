(define-data-var bonuses (map principal uint))

;; Define a constant for the minimum bet required to qualify for a bonus
(define-constant MIN_BET_AMOUNT 100)
(define-data-var promotions (map uint uint))

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

(define-public (get-bonus (user principal))
    (ok (var-get bonuses user))
)

(define-public (redeem-bonus (user principal) (amount uint))
    (begin
        (let ((current-bonus (var-get bonuses user)))
            (if (>= current-bonus amount)
                (begin
                    (map-set bonuses user (- current-bonus amount))
                    (ok "Bonus redeemed successfully"))
                (err "Insufficient bonus balance"))
        )
    )
)
;; Update add-bonus to set expiration date (e.g., 30 days from now)
(define-public (add-bonus (user principal) (amount uint))
    (let ((expiry (block-time + 2592000)))  ;; 30 days in seconds
        (begin
            (if (>= amount MIN_BET_AMOUNT)
                (let ((current-bonus (var-get bonuses user)))
                    (map-set bonuses user (+ current-bonus amount))
                    (map-set bonus-expiry user expiry)
                    (ok "Bonus added successfully"))
                (err "Bet amount is less than minimum required to earn a bonus"))
        )
    )
    (define-public (claim-promotion (user principal) (event-id uint))
    (let ((bonus (map-get promotions event-id)))
        (if (is-some bonus)
            (add-bonus user (unwrap! bonus 0))  ;; Claim the bonus
            (err "Promotion does not exist"))
    )
)

    (define-public (activate-promotion (event-id uint) (bonus-amount uint))
    (begin
        (map-set promotions event-id bonus-amount)
        (ok "Promotion activated"))
)



(define-public (reset-bonus (user principal))
    (begin
        (map-set bonuses user 0)
        (ok "Bonus reset successfully"))
)

(define-read-only (is-bonus-eligible (user principal) (amount uint))
    (if (>= amount MIN_BET_AMOUNT)
        (ok true)
        (ok false)
    )
)
(define-data-var bonus-expiry (map principal uint))

