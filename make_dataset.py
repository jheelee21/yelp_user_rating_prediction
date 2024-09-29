import pandas as pd

f = "./data/yelp_academic_dataset_"
f_business = f + "business.csv"
f_review = f + "review.csv"
f_user = f + "user.csv"
f_review_reduced = "./data/yelp_csv/yelp_academic_dataset_review_reduced.csv"

def user(f):
    df = pd.read_csv(f)
    # dst = "./data/yelp_academic_dataset_user_reduced.csv"
    dst = "test.csv"

    df["friends_count"] = df["friends"].str.split(",").size + 1
    df = df.drop("friends", axis=1)

    df.to_csv(dst, index=False)

def review(f):
    df = pd.read_csv(f)
    dst = "./data/yelp_academic_dataset_review_reduced.csv"

    df["word_count"] = df["text"].str.len()
    df = df.drop("text", axis=1)

    df.to_csv(dst, index=False)

def split_df(f):
    df = pd.read_csv(f)
    dst1 = "." + f.split(".")[-2] + "1.csv"
    dst2 = "." + f.split(".")[-2] + "2.csv"

    n = len(df)
    df1 = df[:n//2]
    df2 = df[n//2:]

    df1.to_csv(dst1, index=False)
    df2.to_csv(dst2, index=False)

# user(f_user)
# review(f_review)

# split_df(f_review_reduced)

