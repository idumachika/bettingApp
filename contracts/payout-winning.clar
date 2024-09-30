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

;; Create a new bet
(define-public (create-bet (event (string-ascii 100)) (options (list 2 (string-ascii 20))) (odds (list 2 uint)))
  (let
    ((new-bet-id (+ (var-get last-bet-id) u1)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set bets
      { bet-id: new-bet-id }
      {
        event: event,
        options: options,
        odds: odds,
        total-pool: u0,
        winning-option: none,
        is-active: true
      }
    )
    (var-set last-bet-id new-bet-id)
    (ok new-bet-id)
  )
)
(define-public (place-bet (bet-id uint) (option uint) (amount uint))
  (let
    (
      (bet (unwrap! (map-get? bets { bet-id: bet-id }) err-not-found))
      (total-pool (+ (get total-pool bet) amount))
    )
    (asserts! (get is-active bet) err-bet-closed)
    (asserts! (>= amount (var-get min-bet-amount)) err-insufficient-balance)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (map-set bets
      { bet-id: bet-id }
      (merge bet { total-pool: total-pool })
    )
    (map-set user-bets
      { bet-id: bet-id, user: tx-sender }
      { amount: amount, option: option }
    )
    (ok true)
  )
)
(define-public (close-betting (bet-id uint))
  (let
    ((bet (unwrap! (map-get? bets { bet-id: bet-id }) err-not-found)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (get is-active bet) err-bet-closed)
    (map-set bets
      { bet-id: bet-id }
      (merge bet { is-active: false })
    )
    (ok true)
  )
)
;; Set the winning option and distribute payouts
(define-public (set-winner-and-payout (bet-id uint) (winning-option uint))
  (let
    (
      (bet (unwrap! (map-get? bets { bet-id: bet-id }) err-not-found))
      (total-pool (get total-pool bet))
      (house-fee (/ (* total-pool (var-get house-fee-percentage)) u100))
      (payout-pool (- total-pool house-fee))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (not (get is-active bet)) err-bet-closed)
    (asserts! (is-none (get winning-option bet)) err-not-found)
    ;; Set the winning option
    (map-set bets
      { bet-id: bet-id }
      (merge bet { winning-option: (some winning-option) })
    )
    ;; Distribute payouts (simplified)
    ;; In a real implementation, you'd iterate through all bettors and calculate individual payouts
    (ok true)
  )
)
;; Read-only functions

;; Get bet details
(define-read-only (get-bet-details (bet-id uint))
  (ok (map-get? bets { bet-id: bet-id }))
)

;; Get user bet details
(define-read-only (get-user-bet (bet-id uint) (user principal))
  (ok (map-get? user-bets { bet-id: bet-id, user: user }))
)
