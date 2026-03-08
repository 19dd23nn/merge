# Plan: Ralph Mode Initialization - Merge Game UI Refinement

## Goal
Refine the UI placeholders in the Merge Game Flutter project, specifically the `BoardScreen` and `MergeTasksWidget`, to improve aesthetics and scalability. This is the first step in "Ralph Mode" (enhanced automation).

## Phase 1: Refining `BoardScreen` UI
- Replace the placeholder "BottomAppBar" text with a functional BottomAppBar.
- Add "Shop" and "Inventory" buttons with appropriate assets (`shop.png`, `cabinet.png`).
- Align the "Back" button (using `brush.png` for now, but maybe `back.png` if exists).
- Use modern styling (shadows, rounded corners).

## Phase 2: Refactoring `MergeTasksWidget`
- Refactor `_buildRequiredItems` to determine image paths dynamically from the `BoardTask` data (title/id).
- Ensure error handling for missing assets.

## Phase 3: Aesthetic Polish
- Add subtle micro-animations or gradients to the `BottomAppBar` if possible.

## Risks
- Missing assets: Some assets like `inventory.png` are not in the list, but `cabinet.png` is available.
- Layout overflow: Ensure the `BottomAppBar` doesn't crowd the `MergeGameBoard`.

## Completion Criteria
1. `BoardScreen` has a high-quality BottomAppBar with icons instead of text.
2. `MergeTasksWidget` uses data-driven image paths.
3. No compilation errors.
