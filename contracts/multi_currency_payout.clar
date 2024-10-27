

(define-data-var currency-balance (map principal (map uint uint))) ;; Maps user to their currency balances
(define-data-var bets (map uint {user: principal, amount: uint, currency: uint})) ;; Maps bet ID to user bet details
(define-data-var bet-counter uint) ;; To keep track of the number of bets


;; Define supported currencies as constants
(define-constant CURRENCY_USD 1)
(define-constant CURRENCY_EUR 2)
(define-constant CURRENCY_BTC 3)
