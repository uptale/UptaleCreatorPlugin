# MCP Tool Contracts

## `uptale_login`

Authenticates through OAuth and stores tokens securely. Use before API-backed workflows when the user is not authenticated.

## `list_workspaces`

Lists accessible workspaces. Use when workspace ID is unknown.

Returns workspace IDs, names, parent group IDs, experience count, and thumbnail experience IDs.

## `list_experiences`

Input:

```json
{
  "workspaceId": "..."
}
```

Use after workspace selection when experience ID is unknown.

## `list_scenes`

Input:

```json
{
  "experienceId": "...",
  "language": "optional"
}
```

Use to inspect existing scene IDs, names, media, and topics/tags.

## `list_experience_media`

Input:

```json
{
  "experienceId": "..."
}
```

Use to detect existing media and avoid duplicate production assumptions.

## `create_scene`

Input:

```json
{
  "experienceId": "...",
  "sceneType": "Void | Pic360 | Video360 | SeeThrough"
}
```

Call once per scene to create. It returns scene ID, name, type, total scene count, and scene object.

## `create_tag`

Input:

```json
{
  "experienceId": "...",
  "sceneId": "...",
  "tagType": "Info | QCM | Canvas | Door",
  "tagData": {}
}
```

Editable fields include:

- `Content.Title`, `Content.Text`, `Content.Format` for Info/QCM.
- `Answers[]` for QCM, including title, correctness, sound, and destination.
- `Caption` for Canvas/Door.
- `ToDestination` for Door.

## `update_tag`

Input:

```json
{
  "experienceId": "...",
  "sceneId": "...",
  "tagId": "...",
  "tagData": {}
}
```

Use for corrections to supported editable fields.

## `delete_tag`

Input:

```json
{
  "experienceId": "...",
  "sceneId": "...",
  "tagId": "..."
}
```

Deletes the tag and removes persisted references. Require explicit confirmation.
