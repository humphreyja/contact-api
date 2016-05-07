```
/contacts                -> Contacts.find_by user OR (org group)
/orgs/:id/contacts       -> Contacts.find_by org
/*/contact/:id/notes     -> Notes.find_by user OR contact
/*/contact/:id/tags      -> Tags.find_by contact

```
