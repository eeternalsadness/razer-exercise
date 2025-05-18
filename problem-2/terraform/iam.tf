data "aws_iam_policy_document" "registry" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads"
    ]
    resources = [aws_s3_bucket.registry.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload"
    ]
    resources = [aws_s3_bucket.registry.arn]
  }
}

resource "aws_iam_policy" "registry" {
  name        = "docker-registry-policy"
  description = "Allows the registry instance to push to and pull from the S3 storage backend"

  policy = data.aws_iam_policy_document.registry.json
}

data "aws_iam_policy_document" "registry-assume" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "registry" {
  name               = "docker-registry-role"
  assume_role_policy = data.aws_iam_policy_document.registry-assume.json
}

resource "aws_iam_policy_attachment" "registry" {
  name       = "docker-registry-policy-attachment"
  roles      = [aws_iam_role.registry.name]
  policy_arn = aws_iam_policy.registry.arn
}

resource "aws_iam_instance_profile" "registry" {
  name = "docker-registry-instance-profile"
  role = aws_iam_role.registry.name
}
