using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using backendPoSlojevima.Models;
using backendPoSlojevima.DAL;
using backendPoSlojevima.Data;
using backendPoSlojevima.BL;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.UI;
using backendPoSlojevima.UI.Interfaces;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Segment.Model;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.AspNet.Identity;
using NETCore.MailKit.Extensions;
using NETCore.MailKit.Infrastructure.Internal;

namespace backendPoSlojevima

{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
          //  services.AddCors();
            services.AddControllers();
            services.AddDbContext<Data.ApplicationDbContext>();
         //   services.AddMvc();
            

          //  services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options =>{});
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII
                            .GetBytes(Configuration.GetSection("AppSettings:Token").Value)),
                        ValidateIssuer = false,
                        ValidateAudience = false
                    };
                });

            services.AddCors(o => o.AddPolicy("MyPolicy", builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            }));
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Latest);


            services.AddTransient<IObjaveUI, ObjaveUI>();
            services.AddTransient<IObjaveBL, ObjaveBL>();
            services.AddTransient<IObjaveDAL, ObjaveDAL>();

            services.AddTransient<ITekstualneObjaveUI, TekstualneObjaveUI>();
            services.AddTransient<ITekstualneObjaveBL, TekstualneObjaveBL>();
            services.AddTransient<ITekstualneObjaveDAL, TekstualneObjaveDAL>();

            services.AddTransient<IKorisnikUI, KorisnikUI>();
            services.AddTransient<IKorisnikBL, KorisnikBL>();
            services.AddTransient<IKorisnikDAL, KorisnikDAL>();

            services.AddTransient<IAdministratorUI,AdministratorUI>();
            services.AddTransient<IAdministratorBL, AdministratorBL>();
            services.AddTransient<IAdministratorDAL, AdministratorDAL>();

            services.AddTransient<ISlikeUI, SlikeUI>();
            services.AddTransient<ISlikeBL, SlikeBL>();
            services.AddTransient<ISlikeDAL, SlikeDAL>();

            services.AddTransient<IKomentariUI, KomentariUI>();
            services.AddTransient<IKomentariBL, KomentariBL>();
            services.AddTransient<IKomentariDAL, KomentariDAL>();

            services.AddTransient<ILajkoviUI, LajkoviUI>();
            services.AddTransient<ILajkoviBL, LajkoviBL>();
            services.AddTransient<ILajkoviDAL, LajkoviDAL>();

            services.AddTransient<IDislajkoviUI, DislajkoviUI>();
            services.AddTransient<IDislajkoviBL, DislajkoviBL>();
            services.AddTransient<IDislajkoviDAL, DislajkoviDAL>();

            services.AddTransient<IReportUI, ReportUI>();
            services.AddTransient<IReportBL, ReportBL>();
            services.AddTransient<IReportDAL, ReportDAL>();

            services.AddTransient<ILajkoviKomentaraUI, LajkoviKomentaraUI>();
            services.AddTransient<ILajkoviKomentaraBL, LajkoviKomentaraBL>();
            services.AddTransient<ILajkoviKomentaraDAL, LajkoviKomentaraDAL>();

            services.AddTransient<IDislajkoviKomentaraUI, DislajkoviKomentaraUI>();
            services.AddTransient<IDislajkoviKomentaraBL, DislajkoviKomentaraBL>();
            services.AddTransient<IDislajkoviKomentaraDAL, DislajkoviKomentaraDAL>();

            services.AddTransient<IReportKomentaraUI, ReportKomentaraUI>();
            services.AddTransient<IReportKomentaraBL, ReportKomentaraBL>();
            services.AddTransient<IReportKomentaraDAL, ReportKomentaraDAL>();

            services.AddTransient<IInstitucijeUI, InstitucijeUI>();
            services.AddTransient<IInstitucijeBL, InstitucijeBL>();
            services.AddTransient<IInstitucijeDAL, InstitucijeDAL>();

            services.AddTransient<IGradUI, GradUI>();
            services.AddTransient<IGradBL, GradBL>();
            services.AddTransient<IGradDAL, GradDAL>();

            services.AddTransient<IGradKorisniciUI, GradKorisniciUI>();
            services.AddTransient<IGradKorisniciBL, GradKorisniciBL>();
            services.AddTransient<IGradKorisniciDAL, GradKorisniciDAL>();

            services.AddTransient<IObjaveKategorijeUI, ObjaveKategorijeUI>();
            services.AddTransient<IObjaveKategorijeBL, ObjaveKategorijeBL>();
            services.AddTransient<IObjaveKategorijaDAL, ObjaveKategorijeDAL>();

            services.AddTransient<IInstitucijeKategorijeUI, InstitucijeKategorijaUI>();
            services.AddTransient<IInstitucijeKategorijeBL, InstitucijeKategorijeBL>();
            services.AddTransient<IInstitucijeKategorijeDAL, InstitucijeKategorijeDAL>();

            services.AddTransient<IKategorijeProblemaUI, KategorijeProblemaUI>();
            services.AddTransient<IKategorijeProblemaBL, KategorijeProblemaBL>();
            services.AddTransient<IKategorijeProblemaDAL, KategorijeProblemaDAL>();

            services.AddTransient<IObavestenjaUI, ObavestenjaUI>();
            services.AddTransient<IObavestenjaBL, ObavestenjaBL>();
            services.AddTransient<IObavestenjaDAL, ObavestenjaDAL>();


        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
             if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

           // app.UseHttpsRedirection();

            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseStaticFiles();
            app.UseCors("MyPolicy");
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
