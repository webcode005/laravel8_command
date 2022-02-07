Laravel surfside
Steps :

1. composer create-project --prefer-dist laravel/laravel laravel8ecommerce
2. composer require livewire/livewire
3. php artisan make:livewire HomeComponent (create page)

	php artisan make:livewire AboutComponent
	php artisan make:livewire ContactComponent
	php artisan make:livewire CartComponent
	php artisan make:livewire CheckoutComponent
	php artisan make:livewire ShopComponent
	php artisan make:livewire CheckoutComponent


	Route
	Route::get('/',HomeComponent::class);
	Route::get('/about-us',AboutComponent::class);
	Route::get('/shop',ShopComponent::class);
	Route::get('/cart',CartComponent::class);
	Route::get('/checkout',CheckoutComponent::class);

4. composer require laravel/jetstream
5. php artisan jetstream:install livewire
Note:(if page not open then use below command

	npm install
	npm run production
)
6. Now make middeware

	php artisan make:middleware AuthAdmin

	(add condition when user logged in or not )



        if (session('utype') ==='ADM') {
            return $next($request);
        } else {
            session()->flash();
            return redirect()->route('login');
        }
        
        inside handle function


	and register them in kernal.php

	now remove dashboard from routeserviceprovider 

	after above process

	inside vendor folder or follow below path

	vendor/laravel/fortify/src/actions/Attempttoauthenticate

	use below code


	use Illuminate\Support\Facades\Auth;
	use App\Providers\RouteServiceProvider;


     and 

	Replace guard if block with below block

		  if ($this->guard->attempt(
            $request->only(Fortify::username(), 'password'),
            $request->boolean('remember'))
        ) 
        {

            if (Auth::user()->utype === 'ADM') {
                session(['utype'=>'ADM']);
                return redirect (RouteServiceProvider:: HOME);
            } 
            elseif (Auth::user()->utype === 'USR') {
                session(['utype'=>'USR']);
                return redirect (RouteServiceProvider:: HOME);
            }
            

            return $next($request);
        }

        inside handle function

7. Now create liwewire component for user and admin and also make route for this component inside middleware and create page template for their dashboard inside views/liwewire/user or views/liwewire/admin

8. create tables for category and product

9. for dummy data
	
	php artisan make:factory CategoryFactory --model=Category
	php artisan make:factory ProductFactory --model=Product

	inside factory page add below code
	use Illuminate\Support\Str;

	then inside definition function in category page

		$category_name = $this->faker->unique()->words($nb=2,$asText=true);

        $slug=Str::slug($category_name);
        
        return [
            'category'=>$category_name,
            'slug'=>$slug,
        ];

     same for product factory page

     .....

10. in seeder directory add below code

		in Databasesseder page

        \App\Models\Category::factory(6)->create();
        \App\Models\Product::factory(22)->create();

	Now run php artisan db:seed


Shop Page

11. replace use/Livewire/Component with below code

	use App\Models\Product;
	use Livewire\Component;
	use Livewire\WithPagination;

	class ShopComponent extends Component
	{
	    use WithPagination;
	    public function render()
	    {
	        $products = Product::paginate(12);
	        return view('livewire.shop-component',['products'=>$products])->layout('layouts.base');
	    }


	    **** pagination button on shop blade

	    {{$products->links()}}


12. for popular and related product use below code on detailcomponent page

	public function render()
    {
        $product = Product::where('slug', $this->slug)->first();
        $popular_product = Product::inRandomOrder()->limit(4)->get();
        $regular_product = Product::where('category_id',$product->category_id)->inRandomOrder()->limit(4)->get();
        return view('livewire.details-component',['product'=>$product,'popular'=>$popular_product,'regular'=>$regular_product])->layout('layouts.base');
    }

**** Shopping Cart *****
13. run composer require hardevine/shoppingcart

 	in config folder inside app page
 	add below code in bottom of provider
 	    Gloudemans\Shoppingcart\ShoppingcartServiceProvider::class,

 	add below code in bottom of aliases
        'Cart' => \Gloudmeans\Shoppingcart\Facades\Cart::class,
	
14. 

