select * from
heart;

-- 좋아요 몇개 받았는지?
select count(*) from
heart where receive_id = 'test';


truncate table heart;

-- 하트클릭
insert into heart(receive_id, user_id) values('friend', 'test');

-- 하트삭제
delete from heart where user_id = 'test' and receive_id = 'friend'; 


select count(*) from heart where user_id = 'test' and receive_id = 'friend';
select count(*) from heart where user_id = '' and receive_id = 'test';

