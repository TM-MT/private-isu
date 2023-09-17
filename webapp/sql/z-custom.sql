-- ADD YOUR CUSTOM QUERY HERE
USE isuconp;
CREATE INDEX idx_post_id_created_at USING BTREE ON comments(post_id, created_at);
