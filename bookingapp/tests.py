from rest_framework.test import APITestCase

class SampleTest(APITestCase):
    def test_a_sample(self):
        self.assertEqual(2, 2)
