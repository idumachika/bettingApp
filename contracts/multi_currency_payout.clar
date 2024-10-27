

(define-data-var currency-balance (map principal (map uint uint))) ;; Maps user to their currency balances
(define-data-var bets (map uint {user: principal, amount: uint, currency: uint})) ;; Maps bet ID to user bet details
(define-data-var bet-counter uint) ;; To keep track of the number of bets
