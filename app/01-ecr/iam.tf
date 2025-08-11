resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [ "sts.amazonaws.com" ]

  thumbprint_list = []
  tags = merge(
    {Name: "chat-app-oidc"},
    local.common_tags
  )
}

resource "aws_iam_role" "github_action_role" {
  name = "chat-app-github-action"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_username}/${var.github_repository}:ref:refs/heads/*"
          }
        }
      }
    ]
  })

  tags = merge(
    {Name: "chat-app-github-action"},
    local.common_tags
  )
}

resource "aws_iam_role_policy_attachment" "github_action_ecr_role_policy_attachment" {
  role       = aws_iam_role.github_action_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}