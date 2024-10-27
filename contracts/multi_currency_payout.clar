

(define-data-var currency-balance (map principal (map uint uint))) ;; Maps user to their currency balances
(define-data-var bets (map uint {user: principal, amount: uint, currency: uint})) ;; Maps bet ID to user bet details
(define-data-var bet-counter uint) ;; To keep track of the number of bets


;; Define supported currencies as constants
(define-constant CURRENCY_USD 1)
(define-constant CURRENCY_EUR 2)
(define-constant CURRENCY_BTC 3)

;; Function to deposit currency
(define-public (deposit (amount uint) (currency uint))
    (if (or (eq? currency CURRENCY_USD)
            (eq? currency CURRENCY_EUR)
            (eq? currency CURRENCY_BTC))
        (begin
            (let ((current-balance (unwrap! (map-get? currency-balance tx-sender) (map)) 0)))
                ;; Update the user's balance
                (map-set currency-balance tx-sender (map-set (unwrap! (map-get? currency-balance tx-sender) (map)) currency (+ current-balance amount)))
                (ok "Deposit successful"))
        )
        (err "Unsupported currency")
    )
)

;; Function to place a bet
(define-public (place-bet (amount uint) (currency uint))
    (if (or (eq? currency CURRENCY_USD)
            (eq? currency CURRENCY_EUR)
            (eq? currency CURRENCY_BTC))
        (let ((current-balance (unwrap! (map-get? currency-balance tx-sender) (map)) 0)))
            (if (>= current-balance amount)
                (let ((bet-id (var-get bet-counter)))
                    ;; Create a new bet
                    (map-set bets bet-id {user: tx-sender, amount: amount, currency: currency})
                    ;; Deduct the amount from the user's balance
                    (map-set currency-balance tx-sender (map-set (unwrap! (map-get? currency-balance tx-sender) (map)) currency (- current-balance amount)))
                    ;; Increment the bet counter
                    (var-set bet-counter (+ bet-id 1))
                    (ok (format "Bet placed successfully. Bet ID: {}", bet-id)))
                (err "Insufficient balance"))
        )
        (err "Unsupported currency")
    )
)


