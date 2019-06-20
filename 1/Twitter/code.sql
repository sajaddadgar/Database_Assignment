-- Section1
select
       *
from
     post
order by
         date desc
limit 5;
-- Section2
select
       post.body
from
     post, user
where
      user.user_id=post.owner_id
  and
      user.username='Matt_Bellamy'
order by
         date;
-- Section3
select
       comment.body, post.body
from
     comment, post
where
      comment.post_id=post.post_id;
-- Section4
select
       user.username, user.email
from
     user
       inner join follow
         on
           follow.following_user_id=user.user_id;
-- Section5
select
       user.username from user inner join post on user.user_id = post.owner_id join liked on  post.owner_id=liked.user_id where post.post_id=liked.post_id;
-- Section6
select
       *
from
     comment
       inner join user
         on
           user.user_id=comment.user_id
where
      user.username='Steven_Wilson'
  and
      comment.date > 2019-01-07
order by
         comment.date asc;


 