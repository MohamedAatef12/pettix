# Adoption Feature Flow

The `lib/features/adoption` module manages the complete journey of finding, researching, and applying for a pet. It is structured using Clean Architecture principles, separating browsing logic from the complex multi-step application form.

## 1. Discovery Phase (Browsing)

| Component | Responsibility |
| :--- | :--- |
| **`AdoptionScreen`** | The main container that provides the `AdoptionBrowseBloc`. |
| **`AdoptionBrowseBloc`** | Manages the state of the pet list, including pagination and initial data fetching via `GetPagedPetsUsecase`. |
| **`AdoptionBody`** | Renders a paged list of pet cards. As the user reaches the bottom, it triggers more data requests. |

## 2. Examination Phase (Pet Profile)

When a user taps a pet card, they are navigated to the `PetProfileScreen`. This screen is divided into modular widgets for high maintainability:

- **`PetGallery`**: Displays high-quality images of the pet.
- **`PetDetails`**: Shows key metrics like age, weight, and breed.
- **`PetDescription`**: Contains the pet's background story.
- **`PetMedicalHistory`**: Lists vaccinations and medical records.
- **`_AdoptBottomBar`**: A sticky footer containing the primary call-to-action button, "**Apply to Adopt**".

## 3. Application Phase (Multi-Step Form)

The application process is handled by `ApplicationScreens` (`application_view.dart`). It uses the `AdoptionBloc` to persist form state across several steps.

### The 6-Step Workflow

1.  **Step 0: Pet Application Start** (`step0_pet_application.dart`)
    - An introductory screen explaining the adoption process requirements.
2.  **Step 1: Personal Information** (`step1_personal_info.dart`)
    - Basic field collection: Name, Email, Phone, Address.
3.  **Step 2: Living Situation** (`step2_living_situation.dart`)
    - Categorical data: Housing type (Appartment/House), family size, and existing pet status.
4.  **Step 3: Pet Experience** (`step3_pet_experience.dart`)
    - Narrative data: Past experience with animals and plans for veterinary care.
5.  **Step 4: Agreements** (`step4_agreements.dart`)
    - Boolean checks for legal terms, house visit permissions, and return policies.
6.  **Step 5: Review** (`step5_review_application.dart`)
    - A summary screen allowing the user to verify all provided information before final submission.

## 4. Finalization & Submission

- **State Transition**: The `AdoptionBloc` validates each step locally before moving to the next.
- **Backend Sync**: Upon clicking "Submit" on the Review screen, the bloc triggers `SubmitAdoptionFormUsecase`.
- **Completion**: `StepSubmitted` (`step6_submitted.dart`) is displayed on success, providing the user with feedback and closing the application funnel.

> [!NOTE]
> The `AdoptionBloc` is reset every time the user enters the application flow from a new pet profile (`ResetForm` event) to ensure data from previous sessions doesn't leak into new applications.
