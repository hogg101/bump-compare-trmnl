# Custom Fields Setup Guide

## Important: Custom Fields Must Be Created Manually

After importing the plugin, **custom fields must be created manually** in the TRMNL UI. They are not automatically created from the `settings.yml` file.

## Steps to Set Up Custom Fields

1. **Go to your Private Plugin settings** in TRMNL dashboard
2. **Click on "Custom Fields" or "Form Builder"** section
3. **Copy and paste the YAML from `custom_fields.yml`** into the custom fields editor

Alternatively, you can add each field manually using the form builder. See the YAML file for the exact field specifications.

## Verifying Custom Fields Work

After creating the fields:

1. **Save the plugin settings**
2. **Go to the plugin's configuration page**
3. **Fill in a test value** (e.g., set `due_date` to a future date)
4. **Check the plugin preview** - it should display the calculated week

## Troubleshooting

If custom fields still don't work:

1. **Check the field key names** - they must match exactly: `due_date`, `locale`, `units`
2. **Verify in Liquid template** - the markup accesses them as `custom_fields.due_date`, `custom_fields.locale`, etc.
3. **Check TRMNL's JS Logs** - in the Markup Editor, expand "JS Logs" to see if there are any errors
4. **Enable Debug Logs** - from plugin settings, enable debug logs to see server-side errors

## Access Pattern in Liquid

The markup accesses custom fields via `trmnl.plugin_settings.custom_fields_values`:

```liquid
{% assign custom_fields = trmnl.plugin_settings.custom_fields_values %}
{% assign due_date = custom_fields.due_date %}
{% assign locale = custom_fields.locale | default: "en-GB" %}
```

Make sure the field keys in the UI match exactly what's used in the markup.
