-- ============================================================
-- TAMIL NADU ASSEMBLY ELECTION 2026
-- Electoral Data Analysis
-- MySQL
-- ============================================================

-- ------------------------------------------------------------
-- 1. DATA VALIDATION
-- Check total records, constituencies records
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_candidate_records
FROM candidate_result;

-- Validate all 234 constituencies are represented
SELECT COUNT(DISTINCT constituency_no) AS total_constituencies
FROM candidate_result;

-- ------------------------------------------------------------
-- 2. WINNER BY CONSTITUENCY
-- Rank candidates by total votes within each constituency
-- ------------------------------------------------------------
select candidate_name_clean,constituency_name,party,vote_rank from(
select *,
dense_rank() over(partition by constituency_no order by total_votes desc) as vote_rank
from candidate_result
) as winner
where winner.vote_rank = 1;

-- ------------------------------------------------------------
-- 3. RUNNER-UP BY CONSTITUENCY
-- ------------------------------------------------------------
select candidate_name_clean,constituency_name,party,vote_rank from(
select *,
dense_rank() over(partition by constituency_no order by total_votes desc) as vote_rank
from candidate_result
) as runner_up 
where runner_up.vote_rank = 2;

-- ------------------------------------------------------------
-- 4. WINNING MARGIN
-- Winner votes minus runner-up votes
-- ------------------------------------------------------------
select (winner.total_votes - runner_up.total_votes) as Winner_Margin,winner.constituency_no from (
select * from(
select total_votes,constituency_no,
dense_rank() over(partition by constituency_no order by total_votes desc) as vote_rank
from candidate_result
) as winner_rank 
where winner_rank.vote_rank = 1
) as winner 
join
(select * from(
select total_votes,constituency_no,
dense_rank() over(partition by constituency_no order by total_votes desc) as vote_rank
from candidate_result
) as runner_up_rank 
where runner_up_rank.vote_rank = 2
) as runner_up
on winner.constituency_no = runner_up.constituency_no;

-- ------------------------------------------------------------
-- 5.CREATE CONSTITUENCY SUMMARY VIEW
-- Created a reusable view with one row per constituency,
-- containing the winner, runner-up, their vote totals,
-- winning parties, and winning margin.
-- ------------------------------------------------------------
CREATE VIEW constituency_summary AS
select constituency_no,
max(constituency_name) as constituency_name,
max(
case when vote_rank = 1 then candidate_name_clean
end
) as winner,
max(
case when vote_rank = 1 then party
end
) as winner_party,
max(
case when vote_rank = 1 then total_votes
end
) as winner_votes,
max(
case when vote_rank = 2 then candidate_name_clean
end
) as Runner,
max(
case when vote_rank = 2 then party
end
) as runnerup_party,
max(
case when vote_rank = 2 then total_votes
end
) as runnerup_votes,
max(
case when vote_rank = 1 then total_votes
end
) - 
max(
case when vote_rank = 2 then total_votes
end
) as Margin
 from(
select *,
dense_rank() over(partition by constituency_no order by total_votes desc) as vote_rank
from candidate_result
) as temp
group by constituency_no;

-- ------------------------------------------------------------
-- 6. TOP 10 CLOSEST CONTESTS
-- Derived from the constituency_summary view created above
-- ------------------------------------------------------------
SELECT *
FROM constituency_summary
ORDER BY margin ASC
LIMIT 10;

-- ------------------------------------------------------------
-- 7. TOP 10 LARGEST VICTORIES
-- Derived from the constituency_summary view created above
-- ------------------------------------------------------------
SELECT *
FROM constituency_summary
ORDER BY margin DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 8. PARTY-WISE SEATS WON
-- Derived from the constituency_summary view
-- Counts the number of constituencies won by each party
-- ------------------------------------------------------------
SELECT
    winner_party,
    COUNT(*) AS winning_seats
FROM constituency_summary
GROUP BY winner_party
ORDER BY winning_seats DESC;

-- ------------------------------------------------------------
-- 9. PARTY SEAT SHARE
-- Calculates each party's share of the 234 constituencies
-- Derived from the constituency_summary view
-- ------------------------------------------------------------
SELECT
    t1.winner_party,
    t1.winning_seats,
    ROUND(
        (t1.winning_seats / t2.total_constituencies) * 100,
        2
    ) AS seat_percentage
FROM (
    SELECT
        winner_party,
        COUNT(*) AS winning_seats
    FROM constituency_summary
    GROUP BY winner_party
) AS t1
JOIN (
    SELECT COUNT(*) AS total_constituencies
    FROM constituency_summary
) AS t2
ORDER BY t1.winning_seats DESC;


-- ------------------------------------------------------------
-- 10. PARTY VOTE SHARE
-- Calculates total votes received by each party and its
-- percentage share of all votes recorded
-- ------------------------------------------------------------
SELECT
    party,
    SUM(total_votes) AS party_total_votes,
    ROUND(
        SUM(total_votes) /
        (SELECT SUM(total_votes)
         FROM candidate_result) * 100,
        2
    ) AS party_vote_share
FROM candidate_result
GROUP BY party
ORDER BY party_vote_share DESC;

-- ------------------------------------------------------------
-- 11. VOTE SHARE VS SEAT SHARE
-- Compares each party's statewide vote share with the
-- percentage of constituencies it won
-- ------------------------------------------------------------
select 
votesharetable.party,
    votesharetable.party_votes,
    round(votesharetable.party_vote_share, 2) AS party_vote_share,
    coalesce(seatsharetable.winning_seats, 0) AS winning_seats,
    coalesce(seatsharetable.seat_percentage, 0) AS seat_percentage
 from (
SELECT 
    party,
    SUM(total_votes) as party_votes,
    SUM(total_votes) / (SELECT 
            SUM(total_votes)
        FROM
            candidate_result) * 100  AS party_vote_share
FROM
    candidate_result
GROUP BY party
) as votesharetable
left join
(
select t1.winner_party,t1.winning_seats,
round((t1.winning_seats/total_no_of_consitituency)*100,2) as seat_percentage
 from (
SELECT 
    winner_party, 
    COUNT(*) AS winning_seats
FROM
    constituency_summary
GROUP BY winner_party) as t1
join (
select count(*) as total_no_of_consitituency
from constituency_summary) as t2
) as seatsharetable
on 
votesharetable.party = seatsharetable.winner_party;

-- ------------------------------------------------------------
-- 12. TURNOUT DATA VALIDATION
-- Confirms all constituencies are present and verifies that
-- General Votes + Postal Votes = Total Votes Polled
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS turnout_records,
    COUNT(DISTINCT constituency_no) AS total_constituencies
FROM constituency_turnout;


SELECT COUNT(*) AS invalid_vote_totals
FROM constituency_turnout
WHERE total_votes_polled <>
      general_votes_polled + postal_votes_polled;

-- ------------------------------------------------------------
-- 13. TOP 10 HIGHEST TURNOUT CONSTITUENCIES
-- ------------------------------------------------------------
SELECT *
FROM constituency_turnout
ORDER BY turnout_percentage DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 14. TOP 10 LOWEST TURNOUT CONSTITUENCIES
-- ------------------------------------------------------------
SELECT *
FROM constituency_turnout
ORDER BY turnout_percentage ASC
LIMIT 10;
