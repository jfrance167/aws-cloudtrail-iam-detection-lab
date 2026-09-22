output "database_name" {
  description = "Glue database name."
  value       = aws_glue_catalog_database.cloudtrail.name
}

output "table_name" {
  description = "Glue table name."
  value       = aws_glue_catalog_table.cloudtrail.name
}

output "workgroup_name" {
  description = "Athena workgroup name."
  value       = aws_athena_workgroup.lab.name
}

