import pandas as pd

f = "./data/yelp_academic_dataset_"
f_business = f + "business.csv"
f_review = f + "review.csv"
f_user = f + "user.csv"
f_user_reduced = "./data/past/yelp_academic_dataset_user_reduced.csv"
f_review_reduced = "./data/reduced/yelp_academic_dataset_review_reduced.csv"

def user(f):
    df = pd.read_csv(f)
    dst = "./data/reduced/yelp_academic_dataset_user_reduced.csv"
    # dst = "test.csv"

    df["friends_count"] = df["friends"].str.count(",") + 1
    df = df.drop("friends", axis=1)
    df["compliments"] = df["compliment_hot"] + df["compliment_more"] + df["compliment_profile"] + df["compliment_cute"] + df["compliment_list"] + \
                        df["compliment_note"] + df["compliment_plain"] + df["compliment_cool"] + df["compliment_funny"] + df["compliment_writer"] + df["compliment_photos"]
    df = df.drop(["compliment_hot", "compliment_more", "compliment_profile", "compliment_cute", "compliment_list", 
                  "compliment_note", "compliment_plain", "compliment_cool", "compliment_funny", "compliment_writer", "compliment_photos"], axis=1)

    df.to_csv(dst, index=False)

def review(f):
    df = pd.read_csv(f)
    # dst = "test.csv"
    dst = "./data/reduced/yelp_academic_dataset_review_reduced.csv"

    df["word_count"] = df["text"].str.count(" ") + 1
    df = df.drop("text", axis=1)
    
    df.to_csv(dst, index=False)

def business(f):
    df = pd.read_csv(f, low_memory=False)
    dst = "./data/reduced/yelp_academic_dataset_business_reduced.csv"
    
    df = df[["business_id", "stars", "review_count", "state"]]
    df = df[df['state'].str.contains("AB")]
    df = df.drop("state", axis=1)

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

if __name__ == "__main__":
    # user(f_user)
    # review(f_review)
    # split_df(f_review_reduced)

    # review("./data/test/review_test.csv")
    business(f_business)