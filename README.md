# claude-daml — Tokenized Asset-Based Lending on Canton Network

> **Proof-of-concept Daml smart contract suite for tokenizing hard-asset collateral loans and distributing fractional yield to accredited investors via a Reg D secondary market on Canton Network.**

---

## Table of Contents

1. [Business Context](#1-business-context)
2. [Capital Flow & Economics](#2-capital-flow--economics)
3. [Why Canton Network & Daml](#3-why-canton-network--daml)
4. [BENJI-Inspired Modular Architecture](#4-benji-inspired-modular-architecture)
5. [Smart Contract Module Reference](#5-smart-contract-module-reference)
6. [End-to-End Workflow](#6-end-to-end-workflow)
7. [Regulatory Framework](#7-regulatory-framework)
8. [Getting Started](#8-getting-started)
9. [Project Structure](#9-project-structure)
10. [Roadmap](#10-roadmap)
11. [License](#11-license)

---

## 1. Business Context

### The Problem: Illiquid Capital Trapped in Hard-Asset Loans

Traditional **Asset-Based Lending (ABL)** allows businesses to unlock capital by pledging hard assets — commercial real estate, manufacturing equipment, fleet vehicles, agricultural assets — as collateral. The lender advances capital (typically 50–80% of appraised collateral value), charges interest (typically 8–12% annualized), and holds a senior secured lien until repayment.

**The bottleneck:** Once a lender funds an ABL loan, that capital is locked for the duration of the loan term. To grow their book, the lender must either:

- Raise additional equity / debt capital (slow, expensive), or
- Sell participations bilaterally via syndication (manual, relationship-dependent, weeks to close)

This friction caps the lender's **capital velocity** — the speed at which deployed capital can be recycled into new deals.

### The Solution: Tokenized ABL on a Regulated Secondary Market

This project demonstrates how a FinTech ABL lender can:

1. **Originate** a collateralized business loan secured by hard assets
2. **Tokenize** the loan into fractional digital securities on Canton Network within hours of closing
3. **Offer** fractional interests to accredited investors under **SEC Reg D Rule 506(c)** via a compliant on-chain secondary market
4. **Recycle** recovered capital immediately into the next loan — dramatically increasing capital turn

The result is an institutional-grade, privacy-preserving, compliance-enforced secondary market that transforms an illiquid ABL loan book into a continuously liquid asset class — inspired by the modular contract architecture pioneered by **Franklin Templeton's BENJI platform** on Canton Network.

---

## 2. Capital Flow & Economics

```
┌─────────────────────────────────────────────────────────────────────┐
│                     CAPITAL FLOW DIAGRAM                            │
│                                                                     │
│  BUSINESS BORROWER                                                  │
│  ┌──────────────────┐                                               │
│  │ Hard Assets      │ ──── pledges collateral ────►                 │
│  │ • Real Estate    │                                               │
│  │ • Equipment      │ ◄─── receives loan capital ───               │
│  │ • Fleet / Agri   │                                               │
│  └──────────────────┘                                               │
│           │                                                         │
│           │  10% annualized interest                                │
│           ▼                                                         │
│  FINTECH ABL LENDER (Originator + Servicer)                        │
│  ┌─────────────────────────────────────────────────────┐           │
│  │  1. Underwrite loan (LTV 50–75%)                    │           │
│  │  2. Register collateral on-chain (CollateralRegistry│           │
│  │  3. Mint LoanTokens (fractional, Reg D)             │           │
│  │  4. List on Canton secondary market                 │           │
│  │  5. Retain 7% spread / servicing fee                │           │
│  └─────────────────────────────────────────────────────┘           │
│           │                                                         │
│           │  3% yield paid to investors                             │
│           ▼                                                         │
│  ACCREDITED INVESTORS (Reg D 506(c))                               │
│  ┌──────────────────┐                                               │
│  │ • Family Offices │  ◄── purchase fractional LoanTokens          │
│  │ • RIAs           │                                               │
│  │ • Hedge Funds    │  ◄── receive proportional yield              │
│  │ • HNW Individuals│       distributed on-chain                   │
│  └──────────────────┘                                               │
│                                                                     │
│  ECONOMICS SUMMARY                                                  │
│  ─────────────────                                                  │
│  Borrower pays:            10.0% annualized interest                │
│  Investor receives:         3.0% yield (distributed on-chain)      │
│  Lender retains:            7.0% spread + origination fees         │
│  Capital recycled:         Immediately upon token sale              │
│  Capital velocity gain:    10–15x vs. traditional hold-to-maturity  │
└─────────────────────────────────────────────────────────────────────┘
```

### Capital Velocity — The Core Value Proposition

| Metric | Traditional ABL (Hold) | Tokenized ABL (This System) |
|--------|------------------------|------------------------------|
| Capital recycled after funding | 12–36 months | Hours to days |
| Deals per $10M capital / year | 1–2 | 15–25 |
| Secondary market participants | Bilateral syndication | Open Reg D marketplace |
| Time to investor settlement | Weeks | Minutes (Canton atomic DVP) |
| Compliance enforcement | Manual | Protocol-level (Daml) |

---

## 3. Why Canton Network & Daml

### Canton Network
Canton is the only public, permissionless blockchain purpose-built for regulated institutional finance. It uniquely combines:

- **Privacy by default** — counterparties see only what they need to see (no public mempool leakage)
- **Atomic DVP** — delivery vs. payment settles simultaneously, eliminating counterparty risk
- **Composability** — smart contracts interoperate across participants without a central coordinator
- **Regulatory alignment** — purpose-built for permissioned, KYC'd participants

Canton processes over **$6 trillion in tokenized assets** and **$280 billion in daily repo transactions**, with participants including HSBC, BNP Paribas, JPMorgan Chase, Goldman Sachs, and Citadel Securities.

### Daml — The Smart Contract Language
Daml (Digital Asset Modeling Language) is the functional, strongly-typed smart contract language that powers Canton. It enforces:

- **Authorization** — every action requires explicit party consent (`signatory`, `controller`)
- **Privacy** — contract payloads are only visible to declared `observer` parties
- **Correctness** — the compiler rejects unsafe code before deployment
- **Auditability** — every state transition is a cryptographically signed, immutable ledger event

### Inspired by BENJI (Franklin Templeton)
Franklin Templeton's **BENJI platform** — the first SEC-registered fund to use blockchain as the official system of record — expanded to Canton Network in November 2025. BENJI pioneered the modular, compliance-first Daml contract pattern this project adopts:

- Compliance enforcement at the **protocol level** (not application level)
- Transfer agent registry as the **legally binding** source of ownership truth
- KYC/AML gating **embedded in every token transfer choice**
- Yield distribution calculated and settled **on-chain, to the second**

This project applies that same architecture to the ABL loan tokenization use case.

---

## 4. BENJI-Inspired Modular Architecture

The contract system is organized as a **hierarchy of composable modules**, each responsible for exactly one domain concern. Higher-level modules call lower-level ones; no module reaches sideways into a peer's internals.

```
┌──────────────────────────────────────────────────────────────────────────┐
│                      MODULE DEPENDENCY HIERARCHY                          │
│                                                                           │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │                 SecondaryMarket.daml  (Layer 4)                  │    │
│  │           Listing · Matching · Settlement · Reporting             │    │
│  └───────────────────────────────┬──────────────────────────────────┘    │
│                                  │ depends on                             │
│  ┌────────────────────────────┐  │  ┌───────────────────────────────┐    │
│  │  YieldDistribution.daml   │  │  │     LoanToken.daml (Layer 3)  │    │
│  │  (Layer 3.5)              │◄─┴─►│  Issuance · Transfer · Yield  │    │
│  │  Yield records · Pending  │     │  Redemption · AccrueYield      │    │
│  │  → Paid · audit trail     │     └──────────┬──────────┬──────────┘    │
│  └────────────────────────────┘               │          │                │
│                                    depends on │          │ depends on     │
│  ┌─────────────────────────────┐             │  ┌───────▼─────────────┐  │
│  │   LoanOrigination.daml      │◄────────────┘  │ InvestorRegistry    │  │
│  │   (Layer 2)                 │                │ .daml  (Layer 2)    │  │
│  │   Application · Commitment  │                │ KYC · Reg D ·       │  │
│  │   ActiveLoan · LTV          │                │ Accreditation       │  │
│  └──────────────┬──────────────┘                └─────────────────────┘  │
│                 │ depends on                                               │
│  ┌──────────────▼──────────────────────────────────────────────────┐     │
│  │              CollateralRegistry.daml  (Layer 1)                  │     │
│  │         Asset registration · Appraisal · LTV · Lien              │     │
│  └──────────────────────────────────────────────────────────────────┘     │
│                                                                           │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │                  Compliance.daml  (Cross-cutting)                 │    │
│  │         Party whitelist · Reg D attestation · AML screening       │    │
│  └──────────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Smart Contract Module Reference

### `Types.daml` — Shared Foundation
**Responsibility:** Defines all shared types, enums, and pure utility functions. Has no dependencies on other project modules — everything else imports from here.

Key types: `CollateralAssetType`, `AssetStatus`, `LoanStatus`, `PaymentFrequency`, `KYCStatus`, `AccreditationTier`, `TokenStatus`, `ListingStatus`, `YieldStatus`, `LoanTerms`, `CollateralInfo`, `TokenTranche`

Key utilities: `calculateDailyInterest`, `computeLTV`, `isValidRate`, `isValidLTV`, `loanDurationDays`, `proRataShare`

---

### `Compliance.daml` — Cross-Cutting Compliance Layer
**Responsibility:** Maintains the canonical whitelist of KYC/AML-cleared parties and Reg D accreditation status. Every transfer choice in every other module fetches from here before proceeding.

Key templates:
- `ParticipantKYC` — operator-controlled KYC record per party; lifecycle: `KYCPending` → `KYCApproved` ↔ `KYCSuspended`; `RevokeKYC` archives
- `InvestorAccreditation` — Reg D 506(c) attestation with expiry; operator-issued per investor

Key choices on `ParticipantKYC`:
- `ApproveKYC` — pending → approved
- `SuspendKYC` — approved → suspended
- `ReinstatKYC` — suspended → approved
- `RevokeKYC` — permanently archives the record

Key choices on `InvestorAccreditation`:
- `RenewAccreditation` — extend expiry (must be forward-only)
- `RevokeAccreditation` — archives the record

---

### `CollateralRegistry.daml` — Layer 1: Hard Asset Registration
**Responsibility:** Creates and maintains the on-chain record of pledged hard assets, their appraised values, and the senior lien held by the lender. Operator acts as the title registry; lender controls lien lifecycle.

Key templates:
- `CollateralAsset` — a registered hard asset (type, description, appraisal, lien status)

Key choices:
- `UpdateAppraisal` (operator) — post a new certified valuation; asset must be Registered or Encumbered
- `PerfectLien` (lender) — Registered → Encumbered; fetches borrower `ParticipantKYC` on-chain as a compliance gate
- `ReleaseLien` (lender) — Encumbered → Released on full repayment
- `LiquidateAsset` (lender) — Encumbered → Liquidated on default; records proceeds
- `nonconsuming GetCurrentLTV` (lender) — compute current loan-to-value ratio

---

### `LoanOrigination.daml` — Layer 2: ABL Loan Lifecycle
**Responsibility:** Models the full lifecycle of an asset-based loan from application through funding, servicing, and closure.

Key templates:
- `LoanApplication` — borrower-initiated loan request
- `LoanCommitment` — lender-issued term sheet; lender is signatory, enabling combined authority on acceptance
- `ActiveLoan` — funded bilateral loan (signatory: lender + borrower)

Key choices:
- `IssueCommitment` (lender on `LoanApplication`) — validates terms, creates `LoanCommitment`
- `AcceptCommitment` (borrower on `LoanCommitment`) — runs with lender+borrower authority; calls `PerfectLien` atomically; creates `ActiveLoan`; returns `(ContractId ActiveLoan, ContractId CollateralAsset)`
- `RejectApplication` / `WithdrawApplication` / `DeclineCommitment` / `RevokeCommitment` — lifecycle exits
- `RecordPayment` (lender on `ActiveLoan`) — partial payment; balance must stay positive
- `RecordFullRepayment` (lender) — final payment must equal outstanding; calls `ReleaseLien`
- `DeclareDefault` (lender) — calls `LiquidateAsset` on collateral
- `nonconsuming GetLTVStatus` (lender) — returns `(currentLTV, isWithinCovenant)`

---

### `InvestorRegistry.daml` — Layer 2: Accredited Investor Onboarding
**Responsibility:** Maintains the register of verified accredited investors and enforces subscription limits. Works in tandem with `Compliance.daml`.

Key templates:
- `OnboardingRequest` — investor-initiated two-party onboarding proposal
- `InvestorProfile` — operator-managed profile tracking subscription cap and cumulative investment

Key choices on `OnboardingRequest`:
- `ApproveOnboarding` (operator) — validates `InvestorAccreditation` ownership; creates `InvestorProfile`
- `RejectOnboarding` / `WithdrawRequest` — lifecycle exits

Key choices on `InvestorProfile`:
- `RecordInvestment` (operator) — increases `currentInvestment`; guards active status and capacity
- `RecordRedemption` (operator) — decreases `currentInvestment`; always permitted (investor can exit)
- `UpdateInvestmentLimit` (operator) — adjust cap; cannot go below current investment
- `DeactivateProfile` / `ReactivateProfile` (operator) — compliance hold toggle
- `nonconsuming VerifyEligibility` (operator) — returns `Bool`; checks active + accreditation not expired + capacity
- `nonconsuming GetAvailableCapacity` (operator) — returns `maxLimit - currentInvestment`

---

### `LoanToken.daml` — Layer 3: Fractional Token Issuance & Yield
**Responsibility:** Mints fractional digital securities representing beneficial ownership in an `ActiveLoan`. Enforces compliance on every transfer. Computes yield on-chain.

Key templates:
- `TokenIssuance` — lender+operator authority record for a token tranche; nonconsuming `MintAllocation` mints per-investor tokens
- `IssuedToken` — a fractional token held by an accredited investor

Key choices on `IssuedToken`:
- `Transfer` (lender) — compliance-gated: fetches receiver `ParticipantKYC` (must be `KYCApproved`) and `InvestorProfile` (must be active); partial transfers produce a residual token; returns `(ContractId IssuedToken, Optional (ContractId IssuedToken))`
- `FreezeToken` / `UnfreezeToken` (lender) — compliance hold; frozen tokens block transfer and redemption
- `nonconsuming AccrueYield` (lender) — returns USD yield for a date range via simple interest
- `RedeemToken` (lender) — Active only; computes pro-rata principal proceeds; archives token

> **Compliance gate (enforced in `Transfer` and `MintAllocation`):** Both choices fetch the receiver's `ParticipantKYC` and `InvestorProfile` on-chain and abort if either check fails — identical to how BENJI enforces compliance at the protocol level.

---

### `YieldDistribution.daml` — Layer 3.5: Yield Payment Audit Trail
**Responsibility:** Provides the immutable per-investor, per-period on-ledger record of yield payments. `IssuedToken.AccrueYield` computes yield but leaves no persisted record; `YieldDistribution` closes that loop and is the on-chain equivalent of a 1099-INT. Depends only on `Types`.

Key templates:
- `YieldDistribution` — lender-issued yield record; fields: token/loan reference, accrual period, token snapshot, yield rate, computed USD yield, and `YieldStatus`

Key choices:
- `MarkPaid` (lender) — `YieldPending` → `YieldPaid`; cash has been delivered off-chain; creates a new contract with updated status
- `VoidDistribution` (lender) — archives a `YieldPending` record on calculation error; lender re-issues a corrected distribution
- `PurgeRecord` (operator) — archives a `YieldPaid` record after the regulatory retention period

---

### `SecondaryMarket.daml` — Layer 4: Reg D Marketplace
**Responsibility:** Operates the on-chain secondary market where accredited investors list and settle fractional loan tokens via atomic DVP on Canton.

Key templates:
- `TokenListing` — seller's offer: token amount, ask price, expiry (signatory: seller + lender)
- `TradeRecord` — immutable audit trail of a settled trade (signatory: lender, observer: operator + seller + buyer)

Key choices on `TokenListing`:
- `MatchListing` (lender) — atomic DVP: compliance gate (buyer KYC + profile) → `IssuedToken.Transfer` → creates `TradeRecord`; returns `(ContractId TradeRecord, ContractId IssuedToken, Optional (ContractId IssuedToken))`
- `CancelListing` (seller) — withdraw before match
- `RevokeListing` (lender) — compliance-driven cancellation
- `ExpireListing` (lender) — clear stale listings

Key choices on `TradeRecord`:
- `PurgeRecord` (operator) — archive after regulatory retention period

---

## 6. End-to-End Workflow

```
Step 1 — COLLATERAL REGISTRATION
  Operator creates CollateralAsset with initial appraisal
  Operator calls UpdateAppraisal → posts certified valuation (status: AssetRegistered)
  [Lender will call PerfectLien in Step 2 as part of AcceptCommitment]

Step 2 — LOAN ORIGINATION
  Borrower calls createCmd LoanApplication with proposed terms + collateral ref
  Lender calls IssueCommitment (on LoanApplication) → LoanCommitment created
  Borrower calls AcceptCommitment (on LoanCommitment) with collateralCid + borrowerKycId
    → atomically calls PerfectLien (CollateralAsset: Registered → Encumbered)
    → creates ActiveLoan (signatory: lender + borrower)
    → returns (ContractId ActiveLoan, ContractId CollateralAsset)
  Capital disbursed off-chain; lender begins servicing

Step 3 — INVESTOR ONBOARDING (one-time per investor, can run in parallel)
  Operator creates ParticipantKYC for investor → calls ApproveKYC
  Operator creates InvestorAccreditation (Reg D 506(c)) with expiry date
  Investor creates OnboardingRequest
  Operator calls ApproveOnboarding (on OnboardingRequest) → InvestorProfile created
  Operator calls RecordInvestment (on InvestorProfile) as tokens are purchased

Step 4 — TOKENIZATION
  Lender + Operator create TokenIssuance record against ActiveLoan
  Lender calls MintAllocation (nonconsuming, per investor) → IssuedToken created per allocation
  Seller (token holder) + Lender co-sign createCmd TokenListing → listing posted on secondary market

Step 5 — SECONDARY MARKET TRADING (Reg D DVP)
  Lender calls MatchListing (on TokenListing) with buyer + buyerKycId + buyerProfileId
    → compliance gate: fetches + asserts buyer ParticipantKYC (must be KYCApproved)
    → compliance gate: fetches + asserts buyer InvestorProfile (must be active)
    → exercises IssuedToken.Transfer → buyer receives token; seller retains residual (if partial)
    → creates TradeRecord (immutable audit trail)
    → returns (ContractId TradeRecord, ContractId IssuedToken, Optional (ContractId IssuedToken))
  Lender's capital is recycled off-chain → funds next ABL loan

Step 6 — ONGOING SERVICING & YIELD
  Borrower makes periodic payments → Lender calls RecordPayment (on ActiveLoan)
  Lender calls AccrueYield (nonconsuming, on IssuedToken) per investor per period
    → returns USD yield = investorYield × tokenFaceValue × tokenAmount × (days/365)
  Lender creates YieldDistribution (YieldPending) for each investor → on-chain yield record
  Lender delivers cash off-chain → calls MarkPaid → YieldDistribution status = YieldPaid
  Lender calls nonconsuming GetLTVStatus → monitors covenant (triggers margin call if needed)

Step 7 — LOAN MATURITY / REPAYMENT
  Borrower makes final payment → Lender calls RecordFullRepayment (on ActiveLoan)
    → exact balance match required
    → atomically calls ReleaseLien → CollateralAsset: Encumbered → Released
  Lender calls RedeemToken (on each IssuedToken) per investor
    → Active tokens only; computes pro-rata principal proceeds
    → archives IssuedToken (token lifecycle complete)
  Collateral returned to borrower off-chain
```

---

## 7. Regulatory Framework

### SEC Regulation D — Rule 506(c)

All secondary market offerings under this system are structured as **Reg D 506(c)** private placements:

| Requirement | Implementation |
|-------------|---------------|
| Accredited investors only | `MatchListing` fetches buyer's `InvestorProfile` (must be active); `MintAllocation` fetches receiver's `InvestorProfile` |
| General solicitation allowed | Public `TokenListing` on secondary market is permitted under 506(c) |
| Issuer verification of accreditation | `InvestorAccreditation` record signed on-chain by operator; checked in `ApproveOnboarding` |
| Form D filing within 15 days | Off-chain compliance obligation of the issuer |
| No resale to non-accredited parties | `Transfer` on `IssuedToken` fetches receiver `ParticipantKYC` (must be `KYCApproved`) and `InvestorProfile` (must be active); aborts otherwise |

### KYC / AML
- Every party (borrower, lender, investor) must hold an active `ParticipantKYC` record in `Compliance.daml`
- KYC lifecycle: `KYCPending` → `ApproveKYC` → `KYCApproved` ↔ `SuspendKYC` ↔ `KYCSuspended`; `RevokeKYC` permanently archives the record
- Sanctions screening updates propagate via `SuspendKYC` (reversible) or `RevokeKYC` (permanent archive)
- All token transfers are blocked for suspended or revoked parties — enforced as a hard abort in `IssuedToken.Transfer` and `SecondaryMarket.MatchListing`

### Collateral Lien Perfection
- `CollateralAsset` (in `CollateralRegistry.daml`) is the on-chain record of the lender's security interest; supplements (does not replace) UCC-1 filings
- `PerfectLien` transitions the asset from `AssetRegistered` → `AssetEncumbered`, associating it with a `LoanId`
- LTV covenant monitoring via `nonconsuming GetCurrentLTV` (on `CollateralAsset`) and `nonconsuming GetLTVStatus` (on `ActiveLoan`) — enables automated margin call triggers

---

## 8. Getting Started

### Prerequisites

```bash
# Install the Daml SDK
curl -sSL https://get.daml.com/ | sh

# Verify
daml version
```

### Build

```bash
git clone https://github.com/hyfisamurai/claude-daml.git
cd claude-daml

# Compile all modules
daml build
```

### Run Tests

```bash
# Full test suite
daml test

# Individual module tests
daml test --files daml/Compliance.daml
daml test --files daml/CollateralRegistry.daml
daml test --files daml/LoanOrigination.daml
daml test --files daml/InvestorRegistry.daml
daml test --files daml/LoanToken.daml
daml test --files daml/YieldDistribution.daml
daml test --files daml/SecondaryMarket.daml
```

### Local Sandbox

```bash
# Start a local ledger
daml sandbox --dar .daml/dist/claude-daml-*.dar

# Open the ledger explorer (separate terminal)
daml navigator server localhost 6865
```

---

## 9. Project Structure

```
claude-daml/
├── CLAUDE.md                       # AI assistant guide (coding conventions, workflow)
├── README.md                       # This file
├── LICENSE                         # MIT
├── daml.yaml                       # Daml SDK manifest (sdk-version: 2.9.0)
│
└── daml/                           # All source and test modules (co-located)
    │
    │   ── Production modules ──────────────────────────────────────────────
    ├── Types.daml                  # Shared types, enums, and pure utilities
    ├── Compliance.daml             # Cross-cutting: KYC/AML whitelist, Reg D
    ├── CollateralRegistry.daml     # Layer 1: Hard asset registration & liens
    ├── LoanOrigination.daml        # Layer 2: ABL loan lifecycle
    ├── InvestorRegistry.daml       # Layer 2: Accredited investor onboarding
    ├── LoanToken.daml              # Layer 3: Fractional token issuance & yield
    ├── YieldDistribution.daml      # Layer 3.5: Yield payment audit trail
    ├── SecondaryMarket.daml        # Layer 4: Reg D marketplace (listing, DVP)
    │
    │   ── Test modules (Daml Script) ──────────────────────────────────────
    ├── TypesTest.daml              # 10 tests — utility function correctness
    ├── ComplianceTest.daml         # 14 tests — KYC lifecycle, Reg D, guards
    ├── CollateralRegistryTest.daml # 20 tests — registration, appraisal, liens
    ├── LoanOriginationTest.daml    # 22 tests — loan pipeline, LTV, defaults
    ├── InvestorRegistryTest.daml   # 24 tests — onboarding, limits, eligibility
    ├── LoanTokenTest.daml          # 24 tests — issuance, transfer, yield, freeze
    ├── YieldDistributionTest.daml  # 17 tests — yield lifecycle, guards, ensures
    ├── SecondaryMarketTest.daml    # 22 tests — DVP, compliance gate, audit trail
    └── E2ETest.daml                #  1 test  — full lifecycle integration (all 8 modules)
```

---

## 10. Roadmap

| Phase | Milestone | Status | Tests |
|-------|-----------|--------|-------|
| 0 | Repository setup, `CLAUDE.md`, `README.md`, `daml.yaml` | ✅ Complete | — |
| 1 | `Types.daml` — shared enums, record types, pure utility functions | ✅ Complete | 10 |
| 2 | `Compliance.daml` — `ParticipantKYC` lifecycle, `InvestorAccreditation` Reg D | ✅ Complete | 14 |
| 3 | `CollateralRegistry.daml` — `CollateralAsset` registration, appraisal, lien perfection | ✅ Complete | 20 |
| 4 | `LoanOrigination.daml` — `LoanApplication` → `LoanCommitment` → `ActiveLoan` pipeline | ✅ Complete | 22 |
| 5 | `InvestorRegistry.daml` — `OnboardingRequest` + `InvestorProfile` subscription tracking | ✅ Complete | 24 |
| 6 | `LoanToken.daml` — `IssuedToken` compliance-gated transfer, yield accrual, redemption | ✅ Complete | 24 |
| 7 | `SecondaryMarket.daml` — `TokenListing` + `TradeRecord` atomic DVP settlement | ✅ Complete | 22 |
| 7a | `YieldDistribution.daml` — per-investor yield payment records; `YieldPending` → `YieldPaid` | ✅ Complete | 17 |
| 7b | `E2ETest.daml` — single-script full lifecycle integration test (all 8 modules) | ✅ Complete | 1 |
| 8 | Canton Network sandbox deployment & integration smoke test | Planned | — |
| 9 | TypeScript codegen (`daml codegen js`) + React reference UI | Planned | — |
| 10 | Reg D compliance audit & legal review | Planned | — |

**154 Daml Script tests** pass across all eight source modules (phases 1–7a), including one end-to-end integration test spanning the full deal lifecycle.

### Completed architecture at a glance

```
SecondaryMarket      TokenListing · TradeRecord · DVP settlement
      ▲
LoanToken            IssuedToken · TokenIssuance · yield · freeze · redeem
      ▲                    ▲
      │          YieldDistribution  YieldPending → YieldPaid · audit trail
      │
LoanOrigination      LoanApplication · LoanCommitment · ActiveLoan
InvestorRegistry     OnboardingRequest · InvestorProfile
      ▲                    ▲
CollateralRegistry   CollateralAsset · appraisal · lien lifecycle
      ▲
Compliance           ParticipantKYC · InvestorAccreditation
      ▲
Types                Enums · record types · pure utilities
```

---

## 11. License

MIT License — Copyright (c) 2026 hyfisamurai

See [LICENSE](./LICENSE) for full terms.

---

## References & Further Reading

- [Franklin Templeton BENJI Platform](https://digitalassets.franklintempleton.com/benji/) — Tokenized fund architecture this project draws inspiration from
- [BENJI Expands to Canton Network (CoinDesk)](https://www.coindesk.com/tech/2025/11/11/franklin-templeton-expands-benji-technology-platform-to-canton-network) — Nov 2025 expansion announcement
- [Canton Network](https://www.canton.network/) — Institutional DLT infrastructure
- [Daml Documentation](https://docs.daml.com/) — Smart contract language reference
- [Daml Standard Library](https://docs.daml.com/daml/stdlib/index.html)
- [OCC Asset-Based Lending Handbook](https://www.occ.treas.gov/publications-and-resources/publications/comptrollers-handbook/files/asset-based-lending/pub-ch-asset-based-lending.pdf) — Regulatory framework for ABL
- [CAIA: Asset-Based Lending Coming of Age](https://caia.org/blog/2025/06/30/asset-based-lending-coming-age-2020s) — Market context
- [SEC Regulation D Overview](https://www.sec.gov/education/smallbusiness/exemptofferings/regd) — Rule 506(c) accredited investor framework
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
