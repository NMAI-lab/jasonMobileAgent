/**
 * Definition of the map:
 * The map is a 4 x 4 grid world. The position of the grid location is 
 * encoded as [X,Y], where the bottom left corner is [0,0] and the top right 
 * corner is [3,3].
 *
 * The map has accessible and inaccessible squares. A visual view of the map is
 * below. The inaccessible square have an X. (start without that)
 *
 * |-------------------------------|
 * |   m   |   n   |   o   |   p   |
 * |       |       |       |   X   |
 * | [0,3] | [1,3] | [2,3] | [3,3] |
 * |-------------------------------|
 * |   i   |   j   |   k   |   l   |
 * |       |   X   |       |       |
 * | [0,2] | [1,2] | [2,2] | [3,2] |
 * |-------------------------------|
 * |   e   |   f   |   g   |   h   |
   |       |   X   |       |       |
 * | [0,1] | [1,1] | [2,1] | [3,1] |
 * |-------------------------------|
 * |   a   |   b   |   c   |   d   |
 * |       |       |   X   |       |
 * | [0,0] | [1,0] | [2,0] | [3,0] |
 * |-------------------------------|
 */

locationName(a,[0,0]).
locationName(b,[1,0]).
locationName(c,[2,0]).
locationName(d,[3,0]).
locationName(e,[0,1]).
locationName(f,[1,1]).
locationName(g,[2,1]).
locationName(h,[3,1]).
locationName(i,[0,2]).
locationName(j,[1,2]).
locationName(k,[2,2]).
locationName(l,[3,2]).
locationName(m,[0,3]).
locationName(n,[1,3]).
locationName(o,[2,3]).
locationName(p,[3,3]).

 
// Possible map transitions. This is a map data structure.
// possible(StartingPosition, PossibleNewPosition)
possible([0,0],[1,0]).
possible([0,0],[0,1]).

possible([1,0],[0,0]).

possible([3,0],[3,1]).

possible([0,1],[0,0]).
possible([0,1],[0,2]).

possible([2,1],[3,1]).
possible([2,1],[2,2]).

possible([3,1],[3,0]).
possible([3,1],[2,1]).
possible([3,1],[3,2]).

possible([0,2],[0,1]).
possible([0,2],[0,3]).

possible([2,2],[3,2]).
possible([2,2],[2,1]).
possible([2,2],[2,3]).

possible([3,2],[3,1]).
possible([3,2],[2,2]).
possible([3,2],[3,3]).

possible([0,3],[0,2]).
possible([0,3],[1,3]).

possible([1,3],[0,3]).
possible([1,3],[2,3]).

possible([2,3],[1,3]).
possible([2,3],[2,2]).


