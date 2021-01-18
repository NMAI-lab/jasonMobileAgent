import jason.architecture.AgArch;
import jason.asSemantics.*;
import jason.asSyntax.Literal;
import jason.asSyntax.Structure;
import java.util.logging.Logger;

public class TestAgentArch extends AgArch {

	private static Logger logger;
	private long reasoningStart;
	private long reasoningStop;
	private int cycleNumber;
	
	@Override
    public void init() throws Exception {
        super.init();
		this.logger = Logger.getLogger("AgentArch");
		this.reasoningStart = 0;
		this.reasoningStop = 0;
		this.cycleNumber = 0;
	}
	

    @Override
    public void broadcast(Message m) throws Exception {
        // Make sure sender parameter is set
        if (m.getSender() == null)  m.setSender(getAgName());

        // Log the message (this is a single agent environment, just log the message)
		this.logger.info(m.getPropCont().toString());
    }

	
	public void reasoningCycleStarting() {
		super.reasoningCycleStarting();
		this.reasoningStart = System.currentTimeMillis();
		this.cycleNumber += 1;
    }

    public void reasoningCycleFinished() {
		super.reasoningCycleFinished();
		this.reasoningStop = System.currentTimeMillis();
		this.logger.info("Reasoning Cycle: " + Integer.toString(this.cycleNumber));
		this.logger.info("Reasoning Period: " + Long.toString(this.reasoningStop - this.reasoningStart));
	}
}
