package org.spicefactory.parsley.lifecycle.asyncinit.model {

/**
 * @author Jens Halm
 */
public class SyncClass {


	private var order: int;


	public function SyncClass (order: int) {
		this.order = order;
	}


	[Inject]
	public var recorder: InitSequenceRecorder;


	[Init]
	public function init (): void {
		recorder.addValue("" + order + "C");
	}
	
	
}
}