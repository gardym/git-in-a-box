# git-in-a-box

## This software will beat you up and take your lunch money.

## DO NOT USE IT YET

1. Put your AWS credentials in ~/.fog like so:

    default:
      aws_access_key_id: <your key here>
      aws_secret_access_key: <your secret here>

2. Fire up your git in a box:

    ./git-in-a-box.rb

3. Test it out:

    ssh -p 2222 git@<your box's ip>

(You should see a greeting, a list of the gitolite default repositories and then be unceremoniously dumped back to your shell)

4. Clone the gitolite-admin repository:

    git clone ssh://git@<your box's ip>:2222/gitolite-admin

5. From here on out, your in gitolite country.

