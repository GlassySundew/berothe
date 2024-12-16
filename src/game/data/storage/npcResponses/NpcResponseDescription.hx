package game.data.storage.npcResponses;

import game.data.storage.npcResponses.NpcActivationTriggerType;

typedef ChainAdvanceTrigger = {
	var requirements : Array<NpcActivationTriggerType>;
	var nextChainId : String;
}

typedef NpcResponseChainElement = {
	var chainId : String;
	var activationTriggers : Array<NpcActivationTriggerType>;
	var actions : Array<NpcResponseType>;
	var chainAdvanceTriggers : Array<ChainAdvanceTrigger>;
}

class NpcResponseDescription extends DescriptionBase {

	public static function fromCdb( entry : Data.NpcResponse ) : NpcResponseDescription {
		var chains : Array<NpcResponseChainElement> = [
			for ( response in entry.responses ) {
				var actions = [for ( action in response.actions ) {
					NpcResponseType.fromCdb( action.type );
				}];
				var activationTriggers = [for ( trigger in response.trigger ) {
					NpcActivationTriggerType.fromCdb( trigger.type );
				}];
				var chainAdvanceTriggers = response.chainAdvanceTriggers == null ? [] : [
					for ( chainAdvanceTrigger in response.chainAdvanceTriggers ) {
						{
							requirements : [
								for ( requirement in chainAdvanceTrigger.requirements ) {
									NpcActivationTriggerType.fromCdb( requirement.type );
								}],
							nextChainId : chainAdvanceTrigger.nextChainId.toString()
						}
					}];

				{
					chainId : response.chainId.toString(),
					activationTriggers : activationTriggers,
					actions : actions,
					chainAdvanceTriggers : chainAdvanceTriggers
				}
			}
		];

		return new NpcResponseDescription(
			entry.id.toString(),
			chains
		);
	}

	public final chains : Array<NpcResponseChainElement>;
	public final chainsById : Map<String, NpcResponseChainElement> = [];

	public function new(
		id : String,
		chains : Array<NpcResponseChainElement>
	) {
		super( id );
		this.chains = chains;

		for ( chain in chains ) {
			chainsById[chain.chainId] = chain;
		}
	}
}
