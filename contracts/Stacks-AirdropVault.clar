;; Airdrop Distribution Contract

;; Define constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERROR-NOT-CONTRACT-OWNER (err u100))
(define-constant ERROR-AIRDROP-ALREADY-CLAIMED (err u101))
(define-constant ERROR-RECIPIENT-NOT-ELIGIBLE (err u102))
(define-constant ERROR-INSUFFICIENT-TOKEN-BALANCE (err u103))
(define-constant ERROR-AIRDROP-NOT-ACTIVE (err u104))
(define-constant ERROR-INVALID-AMOUNT (err u105))
(define-constant ERROR-RECLAIM-PERIOD-NOT-ENDED (err u106))
(define-constant ERROR-INVALID-RECIPIENT (err u107))
(define-constant ERROR-INVALID-PERIOD (err u108))

;; Define data variables
(define-data-var is-airdrop-active bool true)
(define-data-var emergency-timelock uint u0)
(define-data-var total-tokens-distributed uint u0)
(define-data-var airdrop-amount-per-recipient uint u100)
(define-data-var airdrop-start-block uint stacks-block-height)
(define-data-var reclaim-period-length uint u10000) ;; Number of blocks after which unclaimed tokens can be reclaimed

;; Define data maps
(define-map eligible-airdrop-recipients principal bool)
(define-map claimed-airdrop-amounts principal uint)

;; Define fungible token
(define-fungible-token airdrop-distribution-token)

;; Define events
(define-data-var next-event-id uint u0)
(define-map contract-events uint {event-type: (string-ascii 20), data: (string-ascii 256)})

(define-constant TIMELOCK-DELAY u144) ;; 24 hours in blocks (assuming 10-minute block time)

(define-public (initiate-emergency-withdrawal)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERROR-NOT-CONTRACT-OWNER)
    (var-set emergency-timelock (+ stacks-block-height TIMELOCK-DELAY))
    (log-event "emerg-withdrawal" "withdrawal initiated")
    (ok (var-get emergency-timelock))))


;; Event logging function
(define-private (log-event (event-type (string-ascii 20)) (data (string-ascii 256)))
  (let ((event-id (var-get next-event-id)))
    (map-set contract-events event-id {event-type: event-type, data: data})
    (var-set next-event-id (+ event-id u1))
    event-id))

;; Admin functions

(define-public (add-eligible-recipient (recipient-address principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERROR-NOT-CONTRACT-OWNER)
    (asserts! (is-none (map-get? eligible-airdrop-recipients recipient-address)) ERROR-INVALID-RECIPIENT)
    (log-event "recipient-add" "new recipient")
    (ok (map-set eligible-airdrop-recipients recipient-address true))))

(define-public (remove-eligible-recipient (recipient-address principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERROR-NOT-CONTRACT-OWNER)
    (asserts! (is-some (map-get? eligible-airdrop-recipients recipient-address)) ERROR-RECIPIENT-NOT-ELIGIBLE)
    (log-event "recipient-remove" "removed recipient")
    (ok (map-delete eligible-airdrop-recipients recipient-address))))

(define-public (bulk-add-eligible-recipients (recipient-addresses (list 200 principal)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERROR-NOT-CONTRACT-OWNER)
    (log-event "bulk-recipients-add" "recipients added")
    (ok (map add-eligible-recipient recipient-addresses))))

(define-public (update-airdrop-amount (new-amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERROR-NOT-CONTRACT-OWNER)
    (asserts! (> new-amount u0) ERROR-INVALID-AMOUNT)
    (var-set airdrop-amount-per-recipient new-amount)
    (log-event "amount-updated" "amount changed")
    (ok new-amount)))

(define-public (update-reclaim-period (new-period uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERROR-NOT-CONTRACT-OWNER)
    (asserts! (> new-period u0) ERROR-INVALID-PERIOD)
    (var-set reclaim-period-length new-period)
    (log-event "period-updated" "reclaim period changed")
    (ok new-period)))
