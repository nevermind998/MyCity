using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.BL.Interfaces
{
    public interface IReportBL
    {
        List<Report> getAllReport();
        int saveReport(Report data);
        void deleteReportoveByIdObjave(long idObjave);
        void deleteReportoveByIdKorisnika(long idKorisnika);
        List<Report> getReportoveByIdObjave(long idObjave);
        long dajSveReportoveByIdObjave(long idObjave);
        List<Report> getReportoveByKoirsnikId(long idKorisnika);
        List<Korisnik> getKorisnikeKojiReportujuByIdObjave(long idObjave);
        long brojReportovaZaVlasnikaObjava(long idKorisnika);
        int getReportByKorisnikId(long idKorisnika, long idObjave);
        List<Objave> getReportovaneObjave();
        List<Objave> getReportovaneObjaveByIdGrada(long idGrada);
        List<Objave> getReportovaneObjaveByIdGrada7Dana(long idGrada);
        public List<Objave> getReportovaneObjaveByIdGrada30Dana(long idGrada);
        List<KorisnikIRazlogPrijave> getKorisnikeIRazlogPrijave(long idObjave);



        long maxReportova();
        List<RazlogPrijave> getRazlogePrijave();
        //  List<Objave> getReportoveByGradId(long idGrada);
        //   public List<Objave> getObjaveWithReports();
    }
}
