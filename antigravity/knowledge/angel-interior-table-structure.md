# Angel Interior — Locked Table Structure (angelinterior schema)
# Source: verified live quizLaa + wms docker local Supabase 2026-05-19

## RULE: users, attachments, permissions are LOCKED structures. Never change without explicit user approval.

## users
Columns: id (uuid pk), email (text not null), name (text), role (text not null default 'viewer'), isDelete (bool not null default false), createdAt (timestamptz), updatedAt (timestamptz)
Role values: super_admin, admin, editor, staff, viewer
Unique index: email WHERE isDelete=false
RLS: authenticated full access (simple true policies)
NEVER ADD: authId, publicUserId, projectId, phone, avatar

## attachments
Columns: id (uuid pk), storagePath (text not null unique), originalName (text not null default ''), fileSize (bigint), mimeType (text), isDelete (bool not null default false), createdAt (timestamptz), updatedAt (timestamptz)
RLS: anon SELECT WHERE isDelete=false; authenticated full access
NEVER ADD: projectId, uploadedBy

## permissions
Columns: id (uuid pk), roleId (uuid fk role.id cascade), resource (text), action (text), scope (text default 'none'), isDelete (bool), createdAt (timestamptz), updatedAt (timestamptz)
Scope values: all, own, none ONLY — never 'project'
Unique: (roleId, resource, action)
RLS: authenticated full access

## Full canonical reference
See: c:\Users\user\Desktop\angel-interior\ANGEL_TABLE_STRUCTURE.md
