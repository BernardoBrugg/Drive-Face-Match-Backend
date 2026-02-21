from pydantic import BaseModel

class OAuthCallbackRequest(BaseModel):
    code: str

class OAuthTokenResponse(BaseModel):
    access_token: str
    email: str
