# reinforcement_learning_cw2
Implementation of game named Easy21

All code used is in MATLAB.

Rules of Easy 21:
The goal of this assignment is to apply reinforcement learning methods to a simple card game that we call Easy21. This task is similar to the Blackjack example in Sutton and Barto—please note, however, that the rules of the card game are different and non-standard.
1) The game is played with an innite deck of cards (i.e. cards are sampled with replacement)
2) Each draw from the deck results in a value between 1 and 10 (uniformly distributed) with a colour of red (probability 1/3) or black (probability 2/3).
3) There are no aces or picture (face) cards in this game
4) At the start of the game both the player and the dealer draw one black card (fully observed)
5) Each turn the player may either stick or hit
6) If the player hits then she draws another card from the deck
7) If the player sticks she receives no further cards
8) The values of the player’s cards are added (black cards) or subtracted (red cards)
9) If the player’s sum exceeds 21, or becomes less than 1, then she “goes bust” and loses the game (reward -1)
10) If the player sticks then the dealer starts taking turns. The dealer always sticks on any sum of 17 or greater, and hits otherwise. If the dealer goes bust, then the player wins; otherwise, the outcome — win (reward +1), lose (reward -1), or draw (reward 0) — is the player with the largest sum.

Instructions:
Write an environment that implements the game Easy21. Specially, write a function step which takes
as input a state s (dealer’s first card 1-10 and the player’s sum 1-21), and an action a (hit or stick), and
returns a sample of the next state s0 (which may be terminal if the game is finished) and reward r. We
will be using this environment for model-free reinforcement learning, we recommend that you do not
explicitly represent the transition matrix for the MDP. There is no discounting (γ = 1). You should
treat the dealer’s moves as part of the environment, i.e. calling step with a stick action will play out
the dealer’s cards and return the final reward and terminal state. 
