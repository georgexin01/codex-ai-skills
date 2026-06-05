# EcoWorld App Workflow - Template Structure Match (2026-05-13)

## Objective
Use `template/src` as the structural baseline and upgrade `ecoworld-app` into a more complete Vue mobile architecture while preserving live UI behavior.

## Mandatory Structure Baseline (template/src)
- assets/
- config/
- i18n/
- router/
- stores/
- types/
- utils/
- views/
- env.d.ts
- main.ts
- App.vue

## Why this structure is required
1. config: isolates env/provider concerns from UI components.
2. router: page ownership and route-level lifecycle.
3. stores (Pinia): state domain separation, easier testing, predictable mutations.
4. utils/storage: persistence abstraction for localStorage + SSR safety.
5. types (TypeScript): contracts for forms, store state, payloads, and UI data.
6. i18n: locale data and localization-ready screen text.
7. views: container orchestration layer above reusable components.
8. assets/global.css: baseline style reset and app-level tokens.

## EcoWorld migration applied
- Preserved current running mobile UI in `src/App.vue`.
- Added scaffolding folders/files under `ecoworld-app/src`:
  - `assets/global.css`
  - `config/{env.ts,supabase.ts,index.ts}`
  - `i18n/{index.ts,locales/en.json,locales/ms.json,locales/zh.json}`
  - `router/index.ts`
  - `types/{auth.ts,settings.ts,ui.ts,property.ts,contact.ts,index.ts}`
  - `utils/{storage.ts,format.ts}`
  - `stores/{mockData.ts,ui.ts,settings.ts,auth.ts,properties.ts,contact.ts,index.ts}`
  - `views/{splash,home,listing,detail,available,blueprint,contact,settings,login}` (container stubs)
  - `env.d.ts`

## Pinia + storage + dummy data guidance
- Pinia stores must be domain-scoped (ui/auth/settings/properties/contact).
- Persistent settings should use `utils/storage.ts` wrapper.
- Dummy data source must remain centralized in one mock-data module.
- New pages should consume stores, not direct hardcoded scattered state.

## App-agent workflow update
1. Read `template/src` tree and compare with project `src` tree.
2. Create missing architectural folders before editing screen UI.
3. Define shared types before adding new store fields.
4. Implement store + storage persistence before complex page forms.
5. Keep UI stable in App shell while progressively moving logic to views/router.
6. Validate with build after each structural batch.

## Notes
- This workflow records a migration-compatible approach: architecture first, visual continuity preserved.
- Use this file as a required reference for future EcoWorld Vue app refactors.

## Full Template/src Snapshot (100% file list)

# Template src Structure Snapshot

Source: `template/src`

- `c:\Users\user\Desktop\ecoworld2\template\src\views\splash\Splash.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\env.d.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\main.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\settings\Settings.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\favorites\Favorites.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\ui.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\settings.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\mockData.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\loan.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\index.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\favorites.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\cars.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\bookings.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\stores\auth.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\config\supabase.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\config\index.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\config\env.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\assets\global.css`
- `c:\Users\user\Desktop\ecoworld2\template\src\App.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\router\index.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\i18n\index.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\utils\storage.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\utils\loanMath.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\utils\format.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\loan\LoanSheet.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\loan\LoanCalculator.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppDatePicker.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppChip.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppCheckbox.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppButton.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\login\OtpVerify.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\login\Login.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppEmpty.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppRangeSlider.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppRadioGroup.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppInput.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppImage.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppSwitch.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppSelect.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\BottomNav.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\AppHeader.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\CarCard.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\BrandLogo.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\CarCardSkeleton.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\ConfirmModal.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\DealerContactSheet.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\login\Signup.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\LoginModal.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\components\ToastContainer.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\UserFeedback.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\SellCar.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\ProfileEdit.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\Profile.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\Notifications.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\MyLoans.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\MyBookings.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\FreeEstimate.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\profile\DealerAbout.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\i18n\locales\zh.json`
- `c:\Users\user\Desktop\ecoworld2\template\src\i18n\locales\ms.json`
- `c:\Users\user\Desktop\ecoworld2\template\src\i18n\locales\en.json`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\booking\BookingConfirm.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\BrandIndex.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\booking\BookingForm.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\CarDetail.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\auth.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\CarFilterDrawer.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\CarList.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\CompareCars.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\SortActionSheet.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\home\Home.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\InspectionReport.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\ImageLightbox.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\views\cars\ContactSheet.vue`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\favorite.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\dealer.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\car.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\booking.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\loan.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\index.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\settings.ts`
- `c:\Users\user\Desktop\ecoworld2\template\src\types\ui.ts`
