-- Определим пользователя у, которого большее количество подтвержденных друзей(со статусом 2 и 3)
-- и найдем друга, который больше всего отправил сообщений пользователю
  
SELECT 
  from_user_id,
  COUNT(*) as send
FROM messages
WHERE to_user_id=
  (SELECT user_id FROM friendships WHERE status_id IN (2,3) GROUP BY user_id ORDER BY COUNT(*) DESC LIMIT 1)
GROUP BY from_user_id
ORDER BY send DESC;

 -- Подсчитаем общее количество лайков, которые получили 10 самых молодых пользователей

SELECT SUM(likes_sum) FROM
  (SELECT
    (SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id
    AND like_type = 'user') AS likes_sum
  FROM profiles
  ORDER BY birthday
  DESC LIMIT 10) AS user_likes;
    
-- Определим кто больше поставил лайков (всего) - мужчины или женщины?
SELECT
  (SELECT gender FROM profiles WHERE user_id =
  like_user_id) AS gender,
  COUNT(*) AS total
FROM likes
GROUP BY gender
ORDER BY total DESC
LIMIT 1;

-- Найдем 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
	
SELECT
  first_name,
  last_name,
  (SELECT COUNT(*) FROM likes WHERE like_user_id=users.id)+
  (SELECT COUNT(*) FROM media WHERE media.user_id=users.id)+
  (SELECT COUNT(*) FROM messages WHERE messages.from_user_id=users.id) AS activiting_user
FROM users
ORDER BY activiting_user
LIMIT 10;
    