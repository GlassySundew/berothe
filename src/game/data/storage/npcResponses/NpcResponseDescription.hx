package game.data.storage.npcResponses;

import game.data.storage.npcResponses.NpcResponseType;
import game.data.storage.npcResponses.NpcActivationTriggerType;

typedef NpcResponseChainElement = {
	var chainId : String;
	var refocusActions : Array<{triggers : Array<NpcActivationTriggerType>, actions : Array<NpcResponseType> }>;
	var actions : Array<{triggers : Array<NpcActivationTriggerType>, actions : Array<NpcResponseType> }>;
	var chatRestActions : Array<NpcResponseType>;
	var unfocusActions : Array<NpcResponseType>;
}

class NpcResponseDescription extends DescriptionBase {

	public static function fromCdb( entry : Data.NpcResponse ) : NpcResponseDescription {
		var chains : Array<NpcResponseChainElement> = [
			for ( response in entry.responses ) {
				var refocusActions = [for ( refocusAction in response.refocusActions ) {
					triggers : [for ( trigger in refocusAction.trigger ) {
						NpcActivationTriggerType.fromCdb( trigger.type );
					}],
					actions : [for ( action in refocusAction.actions ) {
						NpcResponseType.fromCdb( action.type );
					}]
				}];
				var actions = response.actions == null ? [] : [
					for ( actionEntry in response.actions ) {
						var triggers = [for ( triggerElem in actionEntry.trigger ) {
							NpcActivationTriggerType.fromCdb( triggerElem.type );
						}];
						var actions = [for ( action in actionEntry.actions ) {
							NpcResponseType.fromCdb( action.type );
						}];
						{
							triggers : triggers,
							actions : actions
						}
					}
				];
				var chatRestActions = response.chatRestActions == null ? [] : [
					for ( chatRestAction in response.chatRestActions ) {
						NpcResponseType.fromCdb( chatRestAction.type );
					}
				];
				var unfocusActions = response.unfocusActions == null ? [] : [
					for ( unfocusAction in response.unfocusActions ) {
						NpcResponseType.fromCdb( unfocusAction.type );
					}
				];

				{
					chainId : response.chainId.toString(),
					refocusActions : refocusActions,
					actions : actions,
					chatRestActions : chatRestActions,
					unfocusActions : unfocusActions,
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
