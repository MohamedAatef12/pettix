/// Parameters for updating a pet's adoption status (private=0, available=1).
class UpdatePetStatusParams {
  final int petId;
  final int status;

  const UpdatePetStatusParams({required this.petId, required this.status});
}
