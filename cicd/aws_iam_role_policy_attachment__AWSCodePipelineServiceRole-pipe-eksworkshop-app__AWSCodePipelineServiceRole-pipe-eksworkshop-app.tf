
resource "aws_iam_role_policy_attachment" "AWSCodePipelineServiceRole-pipe-node-js-sample-app__AWSCodePipelineServiceRole-pipe-node-js-sample-app" {
  policy_arn = aws_iam_policy.AWSCodePipelineServiceRole-pipe-node-js-sample-app.arn
  role       = aws_iam_role.AWSCodePipelineServiceRole-pipe-node-js-sample-app.id
}
