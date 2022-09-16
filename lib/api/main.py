from fastapi import FastAPI
import razorpay


app = FastAPI()


RAZORPAY_ID = "rzp_test_G54cjNvyNft50M"
RAZORPAY_SECRET_KEY = "W2POVt4B8cI6DJqKogOaYyfX"


client = razorpay.Client(auth=(RAZORPAY_ID, RAZORPAY_SECRET_KEY))


@app.post("/razorpay/order")
async def create_order(data: dict):

	# data = { "amount": 500, "currency": "INR", "receipt": "order_rcptid_11" }
	payment = client.order.create(data=data)

	return payment