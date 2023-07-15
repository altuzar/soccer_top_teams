![Wave](https://github.com/altuzar/altuzar/blob/7cee95dad410050d9b5bf25060b535b4c865be60/wave.gif)

# Soccer Top Teams Calculator Processor

## Usage

`ruby main.rb sample-input.txt`

## Example

![Wave](https://github.com/altuzar/altuzar/blob/7cee95dad410050d9b5bf25060b535b4c865be60/wave.gif)

## Overview

The SoccerTopTeamsCalculator is a Ruby class designed to process soccer match results and calculate the top teams based on the points earned, where the input could be in the order of terabytes. It provides methods to process matches from a file or standard input, and it generates a matchday summary with the top teams and their respective points.

For a complete list of requirements, refer to the Prompt.md file in the challenge repository.

Example input:

```
San Jose Earthquakes 3, Santa Cruz Slugs 3
Capitola Seahorses 1, Aptos FC 0
Felton Lumberjacks 2, Monterey United 0
Felton Lumberjacks 1, Aptos FC 2
Santa Cruz Slugs 0, Capitola Seahorses 0
Monterey United 4, San Jose Earthquakes 2
```

Example output:

```
Matchday 1
Capitola Seahorses, 3 pts
Felton Lumberjacks, 3 pts
San Jose Earthquakes, 1 pt

Matchday 2
Capitola Seahorses, 4 pts
Aptos FC, 3 pts
Felton Lumberjacks, 3 pts
```

## Decision 1

The biggest blocker for the project is to process data in the order of the terabytes. If there is a structure in memory, or even in a SQL or NOSQL database, it could grow very quickly.

### Option 1 (Recommended):

Store only three variables:

- The current matchday count
- The current matchday results
- The current table

When closing the matchday, the current matchday hash would be cleared and the memory liberated.

The biggest variable after some matchdays would be the current table, but it would be a hash with one key per team. If there are 20 teams, like a normal soccer league, worst case we would have only 20 keys with the aggregate of points for each team, even after a million matches.

For simplicity, in this project, all are stored in Memory, but a proper production system would store it in a relational database or a Key-Value store for persistence.

### Option 2:

Store all the history of matchdays.

If we store each closed matchday, the matchday results hash would grow linearly after each match. This would make the application crash after several matches.

## Decision 2:

When to close a matchday.

### Option 1:

When trying to add another team to the current matchday hash, where the key already exists, or when getting bad data as long as the current matchday hash is not empty.

### Pros:

Make it reliable for data corruption.

### Cons:

May have inconsistencies when data partition if a match result is not recognized.

### Option 2 (Recommended):

In a PubSub system with an idempotent key, we would ensure that the match result is registered at least once.

It would be recommended to store all the match results and have a system to validate any error. What would happen if a match is canceled, or moved to a different date, for example?

### Pros:

Make it more flexible for real-life scenarios.

### Cons:

The cost and maintenance of the system.

## Example Schema

```
Matchday_count: Integer
15
```

```
Current_matchday: Hash
{
	team 1: 3,
	team 2: 2,
	team 3: 3,
	team 4: 1,
	team 5: 0,
	team 6: 3,
}
```

```
Current_table: Hash
{
	team 1: 12,
	team 2: 9,
	team 3: 5,
	team 4: 3,
	team 5: 25,
	team 6: 4,
}
```

## API Design

Here would be added any GraphQL/Rest API change for stakeholders' feedback.

### Endpoints:

```
MatchResultCreate(result: String) -> MatchResult.
GetTopTable(first: Integer, cursor?: PaginationCursor) ->   TablePosition[]
```

### Entities:

```
MatchResult:
{
	HomeTeam: String,
	HomeScore: Integer,
	AwayTeam: String,
	AwayScore: Integer
}

TablePosition:
{
	Position: Integer,
	Team: String,
	Points: Integer
}
```

## References

[Technical Document](https://docs.google.com/document/d/10iab4bKKW2-K3niq1lvH1jqF-ZgvprHM4Qr-hMzELOU/edit#heading=h.rj2e1ciw79g)
