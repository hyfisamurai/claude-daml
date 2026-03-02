# CLAUDE.md — AI Assistant Guide for claude-daml

## Project Overview

**claude-daml** is a Claude Code–assisted repository for developing [Daml](https://www.digitalasset.com/developers) (Digital Asset Modeling Language) smart contracts. The project uses Claude Code to accelerate authoring, reviewing, and testing Daml templates and workflows.

- **License:** MIT (Copyright 2026 hyfisamurai)
- **Language:** Daml (`.daml` files)
- **Purpose:** Build on-ledger smart contract logic using Daml's type-safe, functional, privacy-aware contract model

---

## Repository Layout (Intended Structure)

The project follows the standard Daml SDK project layout:

```
claude-daml/
├── CLAUDE.md               # This file — AI assistant guide
├── README.md               # Human-facing project overview
├── LICENSE                 # MIT license
├── daml.yaml               # Daml project manifest (SDK version, dependencies, modules)
├── daml/                   # Daml source files
│   ├── Main.daml           # Entry-point module (or top-level templates)
│   └── *.daml              # Additional modules as the project grows
├── daml-test/              # Daml Script tests (or inline in modules)
│   └── *.daml
├── scripts/                # Shell helpers (build, deploy, sandbox startup)
└── .daml/                  # Generated build artifacts (git-ignored)
```

> The `daml/` directory is the primary source of truth. All new smart contract logic belongs there.

---

## Technology Stack

| Tool | Purpose |
|------|---------|
| [Daml SDK](https://docs.daml.com/) | Smart contract compiler, runtime, and toolchain |
| `daml build` | Compile `.daml` sources into a `.dar` (Daml Archive) |
| `daml test` | Run Daml Script unit tests |
| `daml sandbox` | Local in-process ledger for development |
| `daml navigator` | Browser-based ledger explorer (for manual testing) |
| `daml codegen` | Generate TypeScript/Java ledger client stubs from `.dar` |
| Claude Code | AI-driven authoring, review, and refactoring of Daml code |

---

## Daml Key Concepts (Essential for AI Assistants)

### Templates
Templates are the core building block — analogous to a class definition for a smart contract:

```daml
template Asset
  with
    issuer : Party
    owner  : Party
    name   : Text
  where
    signatory issuer
    observer  owner

    choice Transfer : ContractId Asset
      with newOwner : Party
      controller owner
      do create this with owner = newOwner
```

### Access Control Primitives
- **`signatory`** — parties whose authority creates/archives the contract; must authorize creation
- **`observer`** — parties who can see the contract but cannot act on it alone
- **`controller`** — party who may exercise a specific `choice`
- **`ensure`** — boolean precondition checked at creation time

### Choices
- `choice` blocks define actions on a contract (analogous to methods)
- Every choice returns a value; archiving is implicit unless `nonconsuming` is specified
- Use `nonconsuming choice` when the contract should survive the action

### Daml Script (Testing)
Tests are written as `Script` actions and run with `daml test`:

```daml
import Daml.Script

myTest : Script ()
myTest = do
  alice <- allocatePartyWithHint "Alice" (PartyIdHint "Alice")
  cid   <- submit alice do createCmd Asset with issuer = alice, owner = alice, name = "Gold"
  pure ()
```

### Contracts vs. Payloads
- A `ContractId t` is an opaque reference on-ledger; payload is fetched with `fetch`
- Always pattern-match or use `fetchAndArchive` rather than ignoring `ContractId` values

---

## Development Workflow

### 1. Initial Setup
```bash
# Install the Daml SDK (if not already installed)
curl -sSL https://get.daml.com/ | sh

# Verify installation
daml version

# Initialize project (only needed once)
daml new claude-daml --template empty-skeleton
```

### 2. Building
```bash
# Compile all Daml modules; produces .daml/dist/<project>-<version>.dar
daml build
```

### 3. Running Tests
```bash
# Run all Daml Script tests in all modules
daml test

# Run tests in a specific module
daml test --files daml/Main.daml
```

### 4. Local Sandbox
```bash
# Start a local ledger with the compiled DAR loaded
daml sandbox --dar .daml/dist/claude-daml-*.dar

# In a separate terminal, open the navigator UI
daml navigator server localhost 6865
```

### 5. Codegen (Optional)
```bash
# Generate TypeScript bindings
daml codegen js .daml/dist/claude-daml-*.dar -o ui/src/daml.js
```

---

## `daml.yaml` Reference

Every Daml project requires a `daml.yaml` manifest. Example:

```yaml
sdk-version: 2.9.0          # Pin to a specific Daml SDK version
name: claude-daml
version: 0.1.0
source: daml                 # Directory containing .daml files
dependencies:
  - daml-prim
  - daml-stdlib
build-options:
  - --ghc-option=-Werror     # Treat warnings as errors (recommended)
```

> Always keep `sdk-version` pinned. Bumping it is a deliberate change that may require migration.

---

## Coding Conventions

### Naming
- **Templates:** `PascalCase` (e.g., `LoanRequest`, `AssetTransfer`)
- **Choices:** `PascalCase` (e.g., `Accept`, `Reject`, `Transfer`)
- **Fields:** `camelCase` (e.g., `issuer`, `loanAmount`, `expiryDate`)
- **Modules:** `PascalCase`, matching the file name (e.g., `module Main where` in `Main.daml`)
- **Test scripts:** suffix with `Test` (e.g., `loanRequestTest : Script ()`)

### Module Structure
Each `.daml` file should start with:
```daml
module MyModule where

import DA.Time
import Daml.Script  -- only in test modules
```

### Daml Best Practices
1. **Always declare `signatory` and `observer` explicitly** — do not leave access control implicit.
2. **Use `ensure` for invariants** — validate preconditions at contract creation.
3. **Prefer `nonconsuming` choices** for read-only or query operations.
4. **Never use partial functions** — avoid `head`, `error`, or unsafe list operations.
5. **Keep choices small** — break complex workflows into discrete contract steps.
6. **Use `DA.Optional` and `DA.Either`** for safe error handling instead of runtime panics.
7. **Avoid storing sensitive data in observers** — use divulgence only when intentional.

### File Organization
- One primary business concept per `.daml` file
- Shared types and utility functions go in a `Types.daml` or `Utils.daml` module
- Test modules should `import Daml.Script` and avoid importing sandbox-only modules in production code

---

## Git Conventions

### Branch Naming
- Feature branches: `feature/<short-description>`
- Fix branches: `fix/<short-description>`
- Claude Code AI branches: `claude/<session-suffix>` (managed automatically)

### Commit Messages
Use imperative mood, concise subject lines:
```
Add LoanRequest template with Accept/Reject choices
Fix signatory not including lender in AssetTransfer
Add Daml Script tests for Transfer workflow
```

### What to Commit
- All `.daml` source files
- `daml.yaml`
- `CLAUDE.md`, `README.md`

### What NOT to Commit (add to `.gitignore`)
```
.daml/
*.dar
node_modules/
```

---

## Testing Guidelines

1. **Every template must have at least one happy-path Script test.**
2. **Test failure paths** using `submitMustFail` for unauthorized actions.
3. **Allocate parties with `allocatePartyWithHint`** to keep test output readable.
4. **Keep tests deterministic** — avoid real-time dependencies; use `DA.Date` literals.
5. **Group related tests** in a single `Script ()` action or a `testGroup`.

Example failure-path test:
```daml
unauthorizedTransferTest : Script ()
unauthorizedTransferTest = do
  alice <- allocatePartyWithHint "Alice" (PartyIdHint "Alice")
  bob   <- allocatePartyWithHint "Bob"   (PartyIdHint "Bob")
  cid   <- submit alice do
    createCmd Asset with issuer = alice, owner = alice, name = "Gold"
  -- Bob should NOT be able to transfer Alice's asset
  submitMustFail bob do
    exerciseCmd cid Transfer with newOwner = bob
```

---

## Common Pitfalls to Avoid

| Pitfall | Correct Approach |
|---------|-----------------|
| Forgetting to include a party as `signatory` | Ensure all obligating parties sign |
| Using `error` or `abort` without `ensure` | Use `ensure` for creation-time checks; `abort` sparingly in choices |
| Archiving a contract in a `nonconsuming` choice | `nonconsuming` means the contract survives — remove it to archive |
| Leaking private data to wrong `observer` | Audit observer lists before adding parties |
| Importing `Daml.Script` in production modules | Only import in `*Test.daml` or dedicated test modules |
| Not pinning `sdk-version` | Always pin; SDK upgrades can be breaking |

---

## AI Assistant Instructions (Claude Code–Specific)

When working in this repository, Claude Code should:

1. **Read `daml.yaml` first** to understand SDK version and module layout before editing `.daml` files.
2. **Run `daml build` after every change** to catch type errors early — Daml is strongly typed and the compiler is the primary source of truth.
3. **Run `daml test` before committing** to confirm no regressions.
4. **Never guess party names or contract IDs** — always derive them from test allocations or ledger queries.
5. **Preserve existing `signatory`/`observer` semantics** — do not add or remove parties without explicit instruction, as it changes the contract's privacy and authorization model.
6. **Prefer adding new choices over modifying existing ones** — changing a choice's signature is a breaking change for existing ledger clients.
7. **Do not modify `.daml/` build artifacts** — these are generated and should never be hand-edited.
8. **When uncertain about a Daml construct**, consult the [Daml documentation](https://docs.daml.com/) rather than guessing.
9. **Commit atomically** — one logical change per commit (e.g., "Add template + its tests" in one commit).
10. **Follow the branch naming convention**: all Claude Code work goes on `claude/<session-suffix>` branches.

---

## Useful Commands Reference

```bash
daml version                          # Show installed SDK version
daml build                            # Compile .daml sources → .dar
daml test                             # Run all Script tests
daml test --files daml/Main.daml      # Run tests in one file
daml sandbox --dar .daml/dist/*.dar   # Start local ledger
daml navigator server localhost 6865  # Open ledger UI
daml codegen js .daml/dist/*.dar -o ui/src/daml.js  # Generate JS bindings
```

---

## Resources

- [Daml Documentation](https://docs.daml.com/)
- [Daml Cheat Sheet](https://docs.daml.com/daml/reference/index.html)
- [Daml Standard Library](https://docs.daml.com/daml/stdlib/index.html)
- [Daml Script Reference](https://docs.daml.com/daml-script/api/index.html)
- [Digital Asset GitHub](https://github.com/digital-asset/daml)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
