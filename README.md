# Starling-Simulation

## Abstract
The aggregate motion of Starlings \textit{(Sturnus vulgaris)} in the sky is one of the most beautiful and impressive examples of collective awareness. It is considered as a means of protection from predators and making the flight more efficient in terms of energy utilization.

We will computationally simulate the phenomenon by modeling each bird as an independent agent communicating and cooperating with other neighbouring agents. Our objective will be to measure from a realistic simulation the average energy spend by each bird, the angular momentum and the force that each bird has to withstand in a typical flight ritual.

But this type of complex motion is rarely seen in computer animation. The simulated flock is an elaboration of a particle system, with the simulated birds being the autonomous agents. The term autonomous agent generally refers to an entity that makes its own choices about how to act in its environment without any influence from a leader or global plan.  The aggregate motion of the simulated flock is the result of the dense interaction of the relatively simple behaviors of the individual simulated birds.
An agent-based model and simulation of starling murmuration. 

##Autonomous Agents

We use the term Autonomous Agents to signify an individual that decides its behaviour in a given situation without the guidance from a leader or a pre-defined objective that each member of the swarm needs to comply with. Some of the important characteristics of an autonomous agent can be summarized as:


1. Processing environment to determine action: This is the more acceptable part. As discussed in preceding sections, autonomous agents take information of other actors from the environment to calculate the force that they need to apply internally to be able to modify their state of motion. They do not act in accordance with any one final end goal.

2. Limited Perception of the environment: Any autonomous agent simulated in a real-world environment is driven by the behaviour of other actors in the environment. However, an important consideration is : How much can an autonomous agent perceive? Given that there is a limit to which any Starling can learn from its surroundings, it is inappropriate to include information of every actor in the environment, to determine the motion of  an autonomous agent. There are various techniques, such as most proximal seven, or 150 degree radar with limited viewing distance. The approach is discussed in further sections.

3. No Single Leader: Flocking in Starlings stems from the principles of collective awareness and intelligence. No single actor determines the motion of the others, yet all the Starlings seem to be flocking in a highly synchronised fashion.

## Theory
The model is based overwhelmingly on the paper 'Self-organized aerial displays of thousands of starlings: a model' by H. Hildenbrandt C. Carere and C.K. Hemelrijka. It's available for free [here](https://academic.oup.com/beheco/article/21/6/1349/333856).


### To run
Download the most recent version of [Processing 3](https://processing.org/) and the rest will be plug-in and play.


## About the program


