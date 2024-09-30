;; 2SureOddBet Smart Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-bet-closed (err u102))
(define-constant err-insufficient-balance (err u103))

;; Data Variables
(define-data-var min-bet-amount uint u1000000) ;; 1 STX
(define-data-var house-fee-percentage uint u5) ;; 5%

;; Data Maps
(define-map bets 
  { bet-id: uint } 
  { 
    event: (string-ascii 100),
    options: (list 2 (string-ascii 20)),
    odds: (list 2 uint),
    total-pool: uint,
    winning-option: (optional uint),
    is-active: bool
  }
)

(define-map user-bets
  { bet-id: uint, user: principal }
  { amount: uint, option: uint }
)