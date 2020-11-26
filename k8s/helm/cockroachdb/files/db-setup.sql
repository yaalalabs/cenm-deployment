
create database if not exists corda;

create table corda.notary_committed_states (
  state_ref varchar(73) not null,
  consuming_transaction_id varchar(64) not null,
  constraint id1 primary key (state_ref)
  );

create table corda.notary_committed_transactions (
  transaction_id varchar(64) not null,
  constraint id2 primary key (transaction_id)
  );

create table corda.notary_request_log (
  id varchar(76) not null,
  consuming_transaction_id varchar(64),
  requesting_party_name varchar(255),
  request_timestamp timestamp not null,
  request_signature bytea not null,
  worker_node_x500_name varchar(255),
  constraint id3 primary key (id),
  index (consuming_transaction_id)
  );

create table corda.notary_double_spends (
  state_ref varchar(73) not null,
  request_timestamp timestamp not null,
  consuming_transaction_id varchar(64) not null,
  constraint id4 primary key (state_ref, consuming_transaction_id),
  index (state_ref, request_timestamp, consuming_transaction_id)
  );

-- Grant permissions

create user if not exists {{ .Values.cenm.user }};

grant select on database corda to {{ .Values.cenm.user }};
grant insert on database corda to {{ .Values.cenm.user }};

grant select on table corda.* to {{ .Values.cenm.user }};
grant insert on table corda.* to {{ .Values.cenm.user }};

