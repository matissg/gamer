# README

This Rails 5.2 demo app is prepared by Matiss Gaigals.

By running `rails db:reset` can clear old data and have teams and first tournament seeded.

Briefly about features of this app:
* 16 teams are predefined, user can edit team labels
* User can create multiple tournaments, all teams participate by default
* User can CRUD tournament
* After creating new tournament, teams are split into divisions 'A', 'B'
* User can auto-generate tournament results by opening tournament in Show mode and pressing "Generate Results"
* Algorithm how tournament results are generated:
  1) First division games are played - each team plays against each other.
     Best teams are defined by a) number of wins, b) total number of scores
  2) Second Top 4 teams from each division go to quarter-finals.
     In quarter finals strongest teams from each division plays against weakest teams from other division
     Winners go to semi-finals
  3) In semi finals teams are split in two groups and each play one game with oponent team
  4) Two teams with wins so far, meet in final - winner is the winner of particular tournament
