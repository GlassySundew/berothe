package game.data.storage.entity.body.view;

enum abstract AnimationKey( String ) from String to String {

	var IDLE = "idle";
	var WALK = "walk";
	var ATTACK_PRIME_IDLE = "attack_prime_idle";
	var ATTACK_PRIME_ATTACK = "attack_prime_attack";
	var ATTACK_SECO_IDLE = "attack_seco_idle";
	var ATTACK_SECO_ATTACK = "attack_seco_attack";
}
