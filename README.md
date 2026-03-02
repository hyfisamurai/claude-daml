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
┌─────────────────────────────────────────────────────────────────────┐
│                    MODULE DEPENDENCY HIERARCHY                       │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              SecondaryMarket.daml  (Layer 4)                │   │
│  │         Listing · Matching · Settlement · Reporting          │   │
│  └────────────────────────┬────────────────────────────────────┘   │
│                           │ depends on                              │
│  ┌────────────────────────▼────────────────────────────────────┐   │
│  │               LoanToken.daml  (Layer 3)                     │   │
│  │      Token issuance · Transfer · Yield · Redemption          │   │
│  └──────────┬───────────────────────────┬───────────────────────┘   │
│             │ depends on                │ depends on                 │
│  ┌──────────▼──────────┐   ┌───────────▼─────────────────────┐    │
│  │  LoanOrigination    │   │  InvestorRegistry.daml (Layer 2) │    │
│  │  .daml  (Layer 2)   │   │  KYC · Reg D · Accreditation     │    │
│  └──────────┬──────────┘   └─────────────────────────────────┘    │
│             │ depends on                                             │
│  ┌──────────▼──────────────────────────────────────────────────┐   │
│  │             CollateralRegistry.daml  (Layer 1)               │   │
│  │        Asset registration · Appraisal · LTV · Lien           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │               Compliance.daml  (Cross-cutting)               │   │
│  │      Party whitelist · Reg D attestation · AML screening     │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 5. Smart Contract Module Reference

### `Compliance.daml` — Cross-Cutting Compliance Layer
**Responsibility:** Maintains the canonical whitelist of KYC/AML-cleared parties and Reg D accreditation status. Every transfer choice in every other module must verify membership here.

Key templates:
- `ComplianceRegistry` — operator-controlled registry of cleared participants
- `KYCRecord` — per-party KYC status, accreditation proof, and jurisdiction
- `AccreditedInvestorAttestation` — signed Reg D 506(c) self-certification with expiry

Key choices:
- `AddKYCRecord` — operator adds or updates a party's compliance record
- `RevokeKYCRecord` — operator removes a party (e.g., sanctions hit)
- `AttestAccreditation` — investor self-attests accredited status (506(c))

---

### `CollateralRegistry.daml` — Layer 1: Hard Asset Registration
**Responsibility:** Creates and maintains the on-chain record of pledged hard assets, their appraised values, and the senior lien held by the lender.

Key templates:
- `CollateralAsset` — a registered hard asset (type, description, appraisal, lien)
- `AppraisalRecord` — timestamped third-party appraisal linked to `CollateralAsset`
- `LienRecord` — lender's perfected security interest against a `CollateralAsset`

Key choices:
- `RegisterAsset` — lender registers a new collateral asset on-chain
- `UpdateAppraisal` — certified appraiser posts a new valuation
- `PerfectLien` — lender records the senior secured lien post-closing
- `ReleaseLien` — lender releases lien upon loan repayment
- `nonconsuming QueryLTV` — compute current loan-to-value ratio

---

### `LoanOrigination.daml` — Layer 2: ABL Loan Lifecycle
**Responsibility:** Models the full lifecycle of an asset-based loan from term sheet through funding, servicing, and repayment.

Key templates:
- `LoanApplication` — borrower-submitted loan request with collateral schedule
- `LoanCommitment` — lender-approved term sheet (rate, LTV, maturity, covenants)
- `ActiveLoan` — funded loan with payment schedule, outstanding balance, and linked collateral

Key choices:
- `ApproveApplication` — lender approves and issues a `LoanCommitment`
- `AcceptCommitment` — borrower accepts terms, triggers funding
- `RecordPayment` — servicer posts a principal + interest payment
- `DeclareDefault` — lender triggers default clause (LTV breach, missed payment)
- `nonconsuming QueryOutstandingBalance` — read current balance without mutation

---

### `InvestorRegistry.daml` — Layer 2: Accredited Investor Onboarding
**Responsibility:** Maintains the register of verified accredited investors eligible to purchase Reg D securities. Works in tandem with `Compliance.daml`.

Key templates:
- `InvestorProfile` — verified investor identity, accreditation tier, and investment limits
- `InvestorWallet` — investor's on-chain token wallet linked to their verified profile
- `SubscriptionAgreement` — signed Reg D subscription document on-chain

Key choices:
- `OnboardInvestor` — operator creates a verified `InvestorProfile` after KYC
- `UpdateAccreditationTier` — adjust investor's accreditation classification
- `SignSubscriptionAgreement` — investor executes Reg D docs on-chain
- `SuspendInvestor` — freeze an investor wallet (sanctions, regulatory hold)

---

### `LoanToken.daml` — Layer 3: Fractional Token Issuance & Yield
**Responsibility:** Mints fractional digital securities representing beneficial ownership in an `ActiveLoan`. Enforces compliance on every transfer. Distributes yield on-chain.

Key templates:
- `LoanTokenIssuance` — the authority record authorizing a token tranche
- `LoanToken` — a fractional token held by an accredited investor
- `YieldAccrual` — per-token accrued interest record (updated by servicer)
- `YieldDistribution` — snapshot of a yield payment event

Key choices:
- `MintTokenTranche` — lender mints tokens against a funded `ActiveLoan`
- `Transfer` — transfer tokens between whitelisted investors (compliance-gated)
- `AccrueYield` — servicer posts accrued interest to `YieldAccrual` records
- `ClaimYield` — investor claims their proportional yield share
- `RedeemAtMaturity` — redeem tokens for principal upon loan repayment
- `nonconsuming QueryAccruedYield` — read accrued yield without side effects

> **Compliance gate (enforced in `Transfer`):** Every token transfer calls `nonconsuming QueryKYCStatus` on `ComplianceRegistry` for both sender and receiver. If either party fails the check, the choice aborts — identical to how BENJI enforces compliance at the protocol level.

---

### `SecondaryMarket.daml` — Layer 4: Reg D Marketplace
**Responsibility:** Operates the on-chain secondary market where accredited investors list, discover, and settle fractional loan tokens via atomic DVP on Canton.

Key templates:
- `TokenListing` — a sell-side offer: token amount, ask price, expiry, seller identity
- `PurchaseOrder` — a buy-side intent: token amount, bid price, buyer identity
- `MatchedTrade` — a matched order awaiting atomic DVP settlement
- `SettledTrade` — immutable record of a completed secondary market transaction

Key choices:
- `ListTokens` — investor lists tokens for sale (compliance-verified)
- `PlaceBid` — buyer places a purchase order (compliance-verified)
- `MatchOrders` — market operator matches compatible listings and orders
- `SettleTrade` — atomic: transfer token to buyer, transfer cash to seller, record `SettledTrade`
- `CancelListing` — seller withdraws an open listing
- `nonconsuming QueryMarketDepth` — read open listings without mutation

---

## 6. End-to-End Workflow

```
Step 1 — COLLATERAL REGISTRATION
  Business submits hard assets → Lender calls RegisterAsset on CollateralRegistry
  Appraiser calls UpdateAppraisal → Lender calls PerfectLien

Step 2 — LOAN ORIGINATION
  Business calls createCmd LoanApplication
  Lender calls ApproveApplication → issues LoanCommitment
  Business calls AcceptCommitment → ActiveLoan created, capital disbursed

Step 3 — INVESTOR ONBOARDING (parallel, one-time per investor)
  Operator calls OnboardInvestor (after KYC/AML)
  Investor calls AttestAccreditation (Reg D 506(c))
  Investor calls SignSubscriptionAgreement

Step 4 — TOKENIZATION
  Lender calls MintTokenTranche on LoanToken → LoanTokens minted
  Lender calls ListTokens on SecondaryMarket → TokenListings created

Step 5 — SECONDARY MARKET TRADING
  Investors call PlaceBid → PurchaseOrders created
  Operator calls MatchOrders → MatchedTrades created
  Operator calls SettleTrade → atomic DVP: tokens → buyers, cash → lender
  Lender's capital is recycled → funds next loan

Step 6 — ONGOING SERVICING & YIELD
  Borrower makes monthly payments → Servicer calls RecordPayment
  Servicer calls AccrueYield on each LoanToken
  Investors call ClaimYield → 3% annualized distributed proportionally

Step 7 — LOAN MATURITY / REPAYMENT
  Borrower repays principal → Servicer calls RecordPayment (final)
  Investors call RedeemAtMaturity → principal returned pro-rata
  Lender calls ReleaseLien → collateral returned to borrower
```

---

## 7. Regulatory Framework

### SEC Regulation D — Rule 506(c)

All secondary market offerings under this system are structured as **Reg D 506(c)** private placements:

| Requirement | Implementation |
|-------------|---------------|
| Accredited investors only | `InvestorRegistry` enforces via `ComplianceRegistry` check |
| General solicitation allowed | Public listing on secondary market is permitted under 506(c) |
| Issuer verification of accreditation | `AccreditedInvestorAttestation` signed on-chain |
| Form D filing within 15 days | Off-chain compliance obligation of the issuer |
| No resale to non-accredited parties | `Transfer` choice aborts if receiver not in whitelist |

### KYC / AML
- Every party (borrower, lender, investor, servicer) must hold an active `KYCRecord` in `ComplianceRegistry`
- Sanctions screening updates propagate via `RevokeKYCRecord`
- All transfers are blocked for suspended or revoked parties — enforced at the smart contract level

### Collateral Lien Perfection
- On-chain `LienRecord` is a record of the lender's security interest (supplements, does not replace, UCC-1 filings)
- LTV covenant monitoring via `nonconsuming QueryLTV` — enables automated margin call triggers

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
    ├── SecondaryMarket.daml        # Layer 4: Reg D marketplace (listing, DVP)
    │
    │   ── Test modules (Daml Script) ──────────────────────────────────────
    ├── TypesTest.daml              # 10 tests — utility function correctness
    ├── ComplianceTest.daml         # 14 tests — KYC lifecycle, Reg D, guards
    ├── CollateralRegistryTest.daml # 20 tests — registration, appraisal, liens
    ├── LoanOriginationTest.daml    # 22 tests — loan pipeline, LTV, defaults
    ├── InvestorRegistryTest.daml   # 24 tests — onboarding, limits, eligibility
    ├── LoanTokenTest.daml          # 24 tests — issuance, transfer, yield, freeze
    └── SecondaryMarketTest.daml    # 22 tests — DVP, compliance gate, audit trail
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
| 8 | Canton Network sandbox deployment & integration smoke test | Planned | — |
| 9 | TypeScript codegen (`daml codegen js`) + React reference UI | Planned | — |
| 10 | Reg D compliance audit & legal review | Planned | — |

**136 Daml Script tests** pass across all seven source modules (phases 1–7).

### Completed architecture at a glance

```
SecondaryMarket   TokenListing · TradeRecord · DVP settlement
      ▲
LoanToken         IssuedToken · TokenIssuance · yield · freeze · redeem
      ▲                ▲
LoanOrigination   LoanApplication · LoanCommitment · ActiveLoan
InvestorRegistry  OnboardingRequest · InvestorProfile
      ▲                ▲
CollateralRegistry  CollateralAsset · appraisal · lien lifecycle
      ▲
Compliance        ParticipantKYC · InvestorAccreditation
      ▲
Types             Enums · record types · pure utilities
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
